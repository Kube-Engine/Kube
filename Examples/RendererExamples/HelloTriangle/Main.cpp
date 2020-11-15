/**
 * @ Author: Matthieu Moinvaziri
 * @ Description: Hello Triangle example
 */

#include <Kube/App/Application.hpp>
#include <Kube/Graphics/RenderPassBeginInfo.hpp>
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

    TriangleApplication(void)
        :   Application("HelloTriangle"),
            _cachedFrames(renderer().cachedFrameCount()),
            _pipelineCache(PipelineCache {
                vertexShader: Graphics::Shader("Shaders/Triangle.vert"),
                fragmentShader: Graphics::Shader("Shaders/Triangle.frag"),
                pipelineLayout: makePipelineLayout(),
                pipeline: makePipeline()
            })
    {
        renderer().frameAcquiredDispatcher().add([this](const Graphics::FrameIndex frameIndex) {
            _cachedFrames.setCurrentFrame(frameIndex);
        });
    }

    virtual void onRender(void) override
    {
        using namespace Graphics;

        // Record a command
        auto pool = renderer().commandPoolManager().acquire(QueueType::Graphics);
        const auto command = pool->add(CommandLevel::Primary, [this](const CommandHandle command) {
            const ClearValue clear { ClearColorValue { 1.0f, 0.0f, 0.0f, 0.0f } };
            const RenderPassBeginInfo renderPassInfo(
                renderer().renderPass(),
                renderer().framebufferManager().currentFramebuffer(),
                Rect2D {
                    Offset2D { 0u, 0u },
                    renderer().swapchain().extent()
                },
                &clear, &clear + 1
            );
            Record::BeginRenderPass(command, &renderPassInfo, VK_SUBPASS_CONTENTS_INLINE);
            Record::EndRenderPass(command);
        });

        // Dispatch the command
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
        renderer().commandDispatcher().dispatch(QueueType::Graphics, &submitInfo, &submitInfo + 1, fence);
        renderer().commandDispatcher().addPresentDependencies(QueueType::Graphics, &signal, &signal + 1, &fence, &fence + 1);
    }

private:
    Graphics::PerFrameCache<Cache> _cachedFrames;
    PipelineCache _pipelineCache;

    Graphics::PipelineLayout makePipelineLayout(void) const
    {
        using namespace Graphics;

        return PipelineLayout(PipelineLayoutModel(nullptr, nullptr, nullptr, nullptr));
    }

    Graphics::Pipeline makePipeline(void) const
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
                shaderStageModels, shaderStageModels + sizeof(shaderStageModels),
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