project(External)

find_package(Threads)

get_filename_component(KubeExternalDir ${CMAKE_CURRENT_LIST_FILE} PATH)


# Vulkan memory allocator
add_library(VulkanMemoryAllocator INTERFACE)

target_include_directories(VulkanMemoryAllocator INTERFACE
    ${KubeExternalDir}/VulkanMemoryAllocator/src
)


# Atomic wait
include(${KubeExternalDir}/AtomicWait/AtomicWait.cmake)