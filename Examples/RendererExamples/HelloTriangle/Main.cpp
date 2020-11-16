/**
 * @ Author: Matthieu Moinvaziri
 * @ Description: Hello Triangle example
 */

#include <Kube/App/Application.hpp>
#include <Kube/Graphics/SubmitInfo.hpp>
#include <Kube/Graphics/Pipeline.hpp>
#include <Kube/Graphics/PipelineLayout.hpp>
#include <Kube/Graphics/Shader.hpp>

using namespace kF;

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
                vertexShader: Graphics::Shader("Shaders/Triangle.vert.spv"),
                fragmentShader: Graphics::Shader("Shaders/Triangle.frag.spv"),
                pipelineLayout: makePipelineLayout(),
                pipeline: makePipeline()
            })
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
        const auto command = pool->add(CommandLevel::Primary, [this](const CommandRecorder &recorder) {
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
            recorder.draw(3, 1, 0, 0);
            recorder.endRenderPass();
        });

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
                VertexInputModel(nullptr, nullptr, nullptr, nullptr),
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