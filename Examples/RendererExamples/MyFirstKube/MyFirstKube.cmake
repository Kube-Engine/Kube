project(MyFirstKube)

get_filename_component(MyFirstKubeDir ${CMAKE_CURRENT_LIST_FILE} PATH)
set(MyFirstKubeShaderDir ${MyFirstKubeDir}/Shaders)

set(Sources
    ${MyFirstKubeDir}/Main.cpp
)

set(MyFirstKubeShaders
    ${MyFirstKubeShaderDir}/Kube.vert
    ${MyFirstKubeShaderDir}/Kube.frag
)

add_executable(${PROJECT_NAME} ${Sources})
target_link_libraries(${PROJECT_NAME} KubeApp)


set(ShaderTargetDir ${CMAKE_BINARY_DIR}/Shaders)
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} ARGS -E make_directory ${ShaderTargetDir}
)

foreach(File ${MyFirstKubeShaders})
    get_filename_component(Filename ${File} NAME)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND glslc ARGS ${File} -o ${ShaderTargetDir}/${Filename}.spv
    )
endforeach()