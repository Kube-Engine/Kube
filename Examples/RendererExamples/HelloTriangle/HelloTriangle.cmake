project(HelloTriangle)

get_filename_component(HelloTriangleDir ${CMAKE_CURRENT_LIST_FILE} PATH)
set(HelloTriangleShaderDir ${HelloTriangleDir}/Shaders)

set(Sources
    ${HelloTriangleDir}/Main.cpp
)

set(HelloTriangleShaders
    ${HelloTriangleShaderDir}/Triangle.vert
    ${HelloTriangleShaderDir}/Triangle.frag
)

add_executable(${PROJECT_NAME} ${Sources})
target_link_libraries(${PROJECT_NAME} KubeApp)

set(ShaderTargetDir ${CMAKE_BINARY_DIR}/Shaders)
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} ARGS -E make_directory ${ShaderTargetDir}
)

foreach(File ${HelloTriangleShaders})
    get_filename_component(Filename ${File} NAME)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND glslc ARGS ${File} -o ${ShaderTargetDir}/${Filename}.spv
    )
endforeach()