project(External)

get_filename_component(KubeExternalDir ${CMAKE_CURRENT_LIST_FILE} PATH)

add_library(VulkanMemoryAllocator INTERFACE)
target_include_directories(VulkanMemoryAllocator INTERFACE ${KubeExternalDir}/VulkanMemoryAllocator/src)