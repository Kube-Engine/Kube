set(KubeRendererExamples)

get_filename_component(KubeRendererExamplesDir ${CMAKE_CURRENT_LIST_FILE} PATH)

include(${KubeRendererExamplesDir}/HelloTriangle/HelloTriangle.cmake)
include(${KubeRendererExamplesDir}/MyFirstKube/MyFirstKube.cmake)