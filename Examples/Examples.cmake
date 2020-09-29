project(KubeExamples)

get_filename_component(KubeExamplesDir ${CMAKE_CURRENT_LIST_FILE} PATH)

include(${KubeExamplesDir}/RendererExamples/RendererExamples.cmake)
