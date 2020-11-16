/**
 * @ Author: Matthieu Moinvaziri
 * @ Description: Hello Triangle example
 */

#include <Kube/App/Application.hpp>
#include <Kube/Graphics/Matrixes.hpp>
#include <Kube/Graphics/SubmitInfo.hpp>
#include <Kube/Graphics/Pipeline.hpp>
#include <Kube/Graphics/PipelineLayout.hpp>
#include <Kube/Graphics/Shader.hpp>
#include <Kube/Graphics/MemoryAllocation.hpp>
#include <Kube/Graphics/Buffer.hpp>

using namespace kF;

struct KubeVertex
{
    Graphics::V2 pos;
    Graphics::V3 color;
};

static const std::vector<KubeVertex> KubeVertices = {
    {{0.0f, -0.5f}, {1.0f, 0.0f, 0.0f}},
    {{0.5f, 0.5f}, {1.0f, 1.0f, 0.0f}},
    {{-0.5f, 0.5f}, {1.0f, 0.0f, 1.0f}}
};

class TriangleApplication : public Application
{
public:
    struct Cache
    {
        Graphics::Semaphore semaphore;
        Graphics::Fence fence;
    };

    struct PipelineCache
    {
        Graphics::Shader vertexShader;
        Graphics::Shader fragmentShader;
        Graphics::PipelineLayout pipelineLayout;
        Graphics::Pipeline pipeline;
    };

    /** @brief Construct a new application with a single pipeline and two shaders  */
    TriangleApplication(void)
        :   Application("HelloTriangle"),
            _cachedFrames(renderer().cachedFrameCount()),
            _pipelineCache(PipelineCache {
                vertexShader: Graphics::Shader("Shaders/Kube.vert.spv"),
                fragmentShader: Graphics::Shader("Shaders/Kube.frag.spv"),
                pipelineLayout: makePipelineLayout(),
                pipeline: makePipeline()
            }),
            _vertexBuffer(makeVertexBuffer()),
            _vertexAllocation(makeVertexAllocation())
    {
        // Make sure that we set the current frame when acquired
        renderer().frameAcquiredDispatcher().add([this](const Graphics::FrameIndex frameIndex) {
            _cachedFrames.setCurrentFrame(frameIndex);
        });
        // Make sure that we recreate viewport dependent ressources on window resize
        renderer().viewSizeDispatcher().add([this] {
            _pipelineCache.pipeline = makePipeline();
        });
    }

    /** @brief Callback when the application starts rendering a new frame */
    virtual void onRender(void) override
    {
        using namespace Graphics;

        // Record a command from a scoped pool of the command pool
        auto pool = renderer().commandPoolManager().acquire(QueueType::Graphics);
        const auto command = pool->add(CommandLevel::Primary,
            [this](const CommandRecorder &recorder) {
                const ClearValue clear { ClearColorValue { 0.0f, 0.0f, 0.0f, 0.0f } };
                const RenderPassBeginInfo renderPassInfo(
                    renderer().renderPass(),
                    renderer().framebufferManager().currentFramebuffer(),
                    Rect2D {
                        Offset2D { 0u, 0u },
                        renderer().swapchain().extent()
                    },
                    &clear, &clear + 1
                );
                recorder.beginRenderPass(renderPassInfo, SubpassContents::Inline);
                recorder.bindPipeline(PipelineBindPoint::Graphics, _pipelineCache.pipeline);
                recorder.bindVertexBuffer(0, _vertexBuffer);
                recorder.draw(static_cast<std::uint32_t>(KubeVertices.size()), 1, 0, 0);
                recorder.endRenderPass();
            }
        );

        // Dispatch the created command with the necessary synchronization
        auto &cache = _cachedFrames.currentCache();
        cache.fence.reset();
        const auto signal = cache.semaphore.handle();
        const auto fence = cache.fence.handle();
        const auto wait = renderer().commandDispatcher().currentFrameAvailableSemaphore();
        const auto waitStage = PipelineStageFlags::ColorAttachmentOutput;
        const SubmitInfo submitInfo(
            &command, &command + 1,
            &wait, &wait + 1,
            &waitStage, &waitStage + 1,
            &signal, &signal + 1
        );

        // Dispatch the command and register semaphores / fences into the queue for frame synchronization
        renderer().commandDispatcher().dispatch(QueueType::Graphics, submitInfo, fence);
        renderer().commandDispatcher().addPresentDependencies(QueueType::Graphics, signal, fence);
    }

private:
    Graphics::PerFrameCache<Cache> _cachedFrames;
    PipelineCache _pipelineCache;
    Graphics::Buffer _vertexBuffer;
    Graphics::MemoryAllocation _vertexAllocation;

    /** @brief Build a vertex buffer for the kube vertices */
    [[nodiscard]] Graphics::Buffer makeVertexBuffer(void)
    {
        return Graphics::BufferModel::MakeVertexLocal(KubeVertices.size() * sizeof(KubeVertex));
    }

    /** @brief Allocate the vertex buffer in local memory using a staging buffer */
    [[nodiscard]] Graphics::MemoryAllocation makeVertexAllocation(void)
    {
        using namespace Graphics;

        // Create a staging buffer and copy vertices
        const BufferSize bufferSize = KubeVertices.size() * sizeof(KubeVertex);
        const Buffer stagingBuffer = Buffer::MakeStaging(bufferSize);
        const MemoryAllocation stagingAllocation = MemoryAllocation::MakeStaging(stagingBuffer.handle(), KubeVertices.begin(), KubeVertices.end());

        // Allocate the local memory and copy from staging buffer
        MemoryAllocation vertexAllocation = MemoryAllocation::MakeLocal(_vertexBuffer.handle());
        const Fence fence(false);
        const CommandHandle command = renderer().commandPoolManager().acquire(QueueType::Transfer)->add(CommandLevel::Primary,
            [this, &stagingBuffer, bufferSize](const CommandRecorder recorder) {
                recorder.copyBuffer(stagingBuffer, _vertexBuffer, BufferCopy(bufferSize));
            });
        renderer().commandDispatcher().dispatch(
            QueueType::Transfer,
            SubmitInfo(&command, &command + 1, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr),
            fence
        );
        fence.wait();
        return vertexAllocation;
    }

    /** @brief Create the pipeline layout */
    [[nodiscard]] Graphics::PipelineLayout makePipelineLayout(void) const
    {
        using namespace Graphics;

        return PipelineLayout(PipelineLayoutModel(nullptr, nullptr, nullptr, nullptr));
    }

    /** @brief Create the pipeline */
    [[nodiscard]] Graphics::Pipeline makePipeline(void) const
    {
        using namespace Graphics;

        const ShaderStageModel shaderStageModels[] = {
            ShaderStageModel(ShaderStageFlags::Vertex, _pipelineCache.vertexShader),
            ShaderStageModel(ShaderStageFlags::Fragment, _pipelineCache.fragmentShader)
        };
        const VertexInputBinding inputBinding(0, sizeof(KubeVertex), VertexInputRate::Vertex);
        const VertexInputAttribute inputAttributes[2] {
            VertexInputAttribute(0, 0, Format::R32G32_SFLOAT, offsetof(KubeVertex, pos)),
            VertexInputAttribute(0, 1, Format::R32G32B32_SFLOAT, offsetof(KubeVertex, color))
        };
        const auto extent = renderer().swapchain().extent();
        const Viewport viewport {
            x: 0.0f,
            y: 0.0f,
            width: static_cast<float>(extent.width),
            height: static_cast<float>(extent.height),
            minDepth: 0.0f,
            maxDepth: 1.0f
        };
        const Rect2D scissor {
            Offset2D { 0, 0 },
            Extent2D { extent }
        };
        const ColorBlendAttachment colorBlendAttachment;
        return Pipeline(
            PipelineModel(
                PipelineCreateFlags::None,
                shaderStageModels, shaderStageModels + sizeof(shaderStageModels) / sizeof(*shaderStageModels),
                VertexInputModel(&inputBinding, &inputBinding + 1, inputAttributes, inputAttributes + sizeof(inputAttributes) / sizeof(*inputAttributes)),
                InputAssemblyModel(PrimitiveTopology::TriangleList),
                TessellationModel(0u),
                ViewportModel(&viewport, &viewport +1, &scissor, &scissor + 1),
                RasterizationModel(PolygonMode::Fill, CullModeFlags::Back, FrontFace::Clockwise),
                MultisampleModel(SampleCountFlags::X1),
                DepthStencilModel(),
                ColorBlendModel(false, LogicOp::Copy, &colorBlendAttachment, &colorBlendAttachment + 1),
                DynamicStateModel(),
                _pipelineCache.pipelineLayout,
                renderer().renderPass(),
                0u
            )
        );
    }
};

int main(void)
{
    try {
        TriangleApplication app;

        app.run();
        return 0;
    } catch (const std::exception &e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }
}