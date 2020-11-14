/**
 * @ Author: Matthieu Moinvaziri
 * @ Description: Hello Triangle example
 */

#include <Kube/App/Application.hpp>
#include <Kube/Graphics/RenderPassBeginInfo.hpp>
#include <Kube/Graphics/SubmitInfo.hpp>

class TriangleApplication : public kF::Application
{
public:
    struct Cache
    {
        kF::Graphics::Semaphore semaphore;
        kF::Graphics::Fence fence;
    };

    TriangleApplication(void) : kF::Application("HelloTriangle"), _cachedFrames(renderer().cachedFrameCount())
    {
        renderer().frameAcquiredDispatcher().add([this](const kF::Graphics::FrameIndex frameIndex) {
            _cachedFrames.setCurrentFrame(frameIndex);
        });
    }

    virtual void onRender(void) override
    {
        using namespace kF::Graphics;

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
    kF::Graphics::PerFrameCache<Cache> _cachedFrames;
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