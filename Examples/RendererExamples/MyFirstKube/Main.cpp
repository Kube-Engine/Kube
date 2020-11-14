/**
 * @ Author: Matthieu Moinvaziri
 * @ Description: Hello Triangle example
 */

#include <iostream>

#include <Kube/App/Application.hpp>
#include <Kube/Graphics/Matrixes.hpp>
#include <Kube/Graphics/RenderModel.hpp>
#include <Kube/Graphics/LayoutModel.hpp>

struct RenderData
{
    kF::Graphics::V2 pos;
    kF::Graphics::V3 color;
};

const std::vector<RenderData> vertices = {
    {{0.0f, -0.5f}, {1.0f, 0.0f, 0.0f}},
    {{0.5f, 0.5f}, {1.0f, 1.0f, 0.0f}},
    {{-0.5f, 0.5f}, {1.0f, 0.0f, 1.0f}}
};

class KubeApplication : public kF::Application
{
public:
    KubeApplication(void) : kF::Application("MyFirstKube"),
        _vertexBuffer(getRenderer().bufferPool().addBuffer(
            kF::Graphics::BufferModel::FromContainer(
                vertices,
                kF::Graphics::BufferModel::Location::Local,
                kF::Graphics::BufferModel::Usage::Vertex
            )
        )),
        _pipeline(getRenderer().pipelineManager().addPipeline(kF::Graphics::PipelineModel {
            // Pipeline's shaders
            shaders: {
                { kF::Graphics::ShaderType::Vertex, "Shaders/Kube.vert.spv" },
                { kF::Graphics::ShaderType::Fragment, "Shaders/Kube.frag.spv" }
            },
            // Pipeline's shaders input layout model
            layoutModel: kF::Graphics::LayoutModel {
                // A binding describes a data buffer
                bindings: {
                    kF::Graphics::LayoutBinding {
                        binding: 0, // Buffer index
                        stride: sizeof(RenderData), // This buffer is filled with RenderData
                        inputRate: VK_VERTEX_INPUT_RATE_VERTEX
                    }
                },
                // Attributes describe how variables are arranged in a buffer
                attributes: {
                    kF::Graphics::LayoutAttribute {
                        location: 0, // Location in the shader
                        binding: 0, // Parent binding index
                        format: VK_FORMAT_R32G32_SFLOAT, // Contains 2 floats
                        offset: offsetof(RenderData, pos) // Targeting 'pos' member
                    },
                    kF::Graphics::LayoutAttribute {
                        location: 1, // Location in the shader
                        binding: 0, // Parent binding index
                        format: VK_FORMAT_R32G32B32_SFLOAT, // Contains 3 floats
                        offset: offsetof(RenderData, color) // Targeting 'color' member
                    }
                }
            }
        })),
        // Draw command to execute
        _drawCommand(getRenderer().getCommandPool().addCommand(kF::Graphics::CommandModel {
            // Command's lifecycle
            lifecycle: kF::Graphics::CommandModel::Lifecycle::Manual,
            // Command's render model
            data: kF::Graphics::RenderModel {
                pipeline: _pipeline,
                vertexCount: 3, // Draw cube's vertexes
                instanceCount: 1, // Draw it once
                vertexOffset: 0, // No offset in vertex
                instanceOffset: 0, // No offset in instance
                buffers: { _vertexBuffer }, // Associated vertex buffer
                offsets: { 0 } // Vertex buffer offset
            }
        }))
    {
        // We add the command to the drawer so it'll draw it
        getRenderer().drawer().addCommandIndex(_drawCommand);
    }

private:
    kF::Graphics::BufferIndex _vertexBuffer {};
    kF::Graphics::PipelineIndex _pipeline {};
    kF::Graphics::CommandIndex _transferCommand {}, _drawCommand {};
};

int main(void)
{
    try {
        KubeApplication app;

        app.run();
        return 0;
    } catch (const std::exception &e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }
}