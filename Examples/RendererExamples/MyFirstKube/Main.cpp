/**
 * @ Author: Matthieu Moinvaziri
 * @ Description: Hello Triangle example
 */

#include <iostream>

#include <Kube/App/Application.hpp>
#include <Kube/Graphics/Maths.hpp>
#include <Kube/Graphics/RenderModel.hpp>
#include <Kube/Graphics/LayoutModel.hpp>

struct RenderData
{
    kF::V2 pos;
    kF::V3 color;
};

const std::vector<RenderData> vertices = {
    {{0.0f, -0.5f}, {1.0f, 0.0f, 0.0f}},
    {{0.5f, 0.5f}, {0.0f, 1.0f, 0.0f}},
    {{-0.5f, 0.5f}, {0.0f, 0.0f, 1.0f}}
};

class KubeApplication : public kF::Application
{
public:
    KubeApplication(void) : kF::Application("MyFirstKube"),
        _staggingBuffer(getRenderer().getBufferPool().addBuffer(kF::BufferModel::FromVector(vertices))),
        // _vertexBuffer(getRenderer().getBufferPool().addBuffer()),
        _pipeline(getRenderer().getPipelinePool().addPipeline(kF::PipelineModel {
            // Pipeline's shaders
            .shaders = {
                { kF::ShaderType::Vertex, "Shaders/Kube.vert.spv" },
                { kF::ShaderType::Fragment, "Shaders/Kube.frag.spv" }
            },
            // Pipeline's shaders input layout model
            .layoutModel = kF::LayoutModel {
                // A binding describes a data buffer
                .bindings = {
                    kF::LayoutBinding {
                        .binding = 0, // Buffer index
                        .stride = sizeof(RenderData), // This buffer is filled with RenderData
                        .inputRate = VK_VERTEX_INPUT_RATE_VERTEX
                    }
                },
                // Attributes describe how variables are arranged in a buffer
                .attributes = {
                    kF::LayoutAttribute {
                        .location = 0, // Location in the shader
                        .binding = 0, // Parent binding index
                        .format = VK_FORMAT_R32G32_SFLOAT, // Contains 2 floats
                        .offset = offsetof(RenderData, pos) // Targeting 'pos' member
                    },
                    kF::LayoutAttribute {
                        .location = 1, // Location in the shader
                        .binding = 0, // Parent binding index
                        .format = VK_FORMAT_R32G32B32_SFLOAT, // Contains 3 floats
                        .offset = offsetof(RenderData, color) // Targeting 'color' member
                    }
                }
            }
        })),
        _transferCommand(getRenderer().getCommandPool().addCommand(kF::CommandModel {

        })),
        // Draw command to execute
        _drawCommand(getRenderer().getCommandPool().addCommand(kF::CommandModel {
            // Command's pipeline
            .pipeline = _pipeline,
            // Command's render model
            .renderModel = kF::RenderModel {
                .vertexCount = 3, // Draw cube's vertexes
                .instanceCount = 1, // Draw it once
                .vertexOffset = 0, // No offset in vertex
                .instanceOffset = 0, // No offset in instance
                .buffers = { _vertexBuffer }, // Associated vertex buffer
                .offsets = { 0 } // Vertex buffer offset
            }
        }))
    {
        // We add the command to the drawer so it'll draw it
        // getRenderer().getDrawer().addCommandIndex(_vertexCommand);
    }

private:
    kF::BufferIndex _staggingBuffer {}, _vertexBuffer {};
    kF::PipelineIndex _pipeline {};
    kF::CommandIndex _transferCommand {}, _drawCommand {};
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