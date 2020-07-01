project(External)

get_filename_component(KubeExternalDir ${CMAKE_CURRENT_LIST_FILE} PATH)

add_library(ParallelHashmap INTERFACE)
target_include_directories(ParallelHashmap INTERFACE ${KubeExternalDir}/parallel-hashmap)