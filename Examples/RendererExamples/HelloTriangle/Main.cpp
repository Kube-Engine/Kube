/**
 * @ Author: Matthieu Moinvaziri
 * @ Description: Hello Triangle example
 */

#include <iostream>

#include <Kube/App/Application.hpp>

class TriangleApplication : public kF::Application
{
public:
    TriangleApplication(void) : kF::Application("HelloTriangle"),
        _pipeline(getRenderer().getPipelinePool().addPipeline(kF::Graphics::PipelineModel {
            // Pipeline's shaders
            shaders: {
                { kF::Graphics::ShaderType::Vertex, "Shaders/Triangle.vert.spv" },
                { kF::Graphics::ShaderType::Fragment, "Shaders/Triangle.frag.spv" }
            }
        })),
        // Draw command to execute
        _command(getRenderer().getCommandPool().addCommand(kF::Graphics::CommandModel {
            // Command's pipeline
            pipeline: _pipeline,
            // Command's render model
            renderModel: kF::Graphics::RenderModel {
                vertexCount: 3, // Draw 3 vertexes
                instanceCount: 1 // Draw it once
            }
        }))
    {
        // We add the command to the drawer so it'll draw it
        getRenderer().getDrawer().addCommandIndex(_command);
    }

private:
    kF::Graphics::PipelineIndex _pipeline;
    kF::Graphics::CommandIndex _command;
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