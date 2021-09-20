get_filename_component(CompileOptionsRoot ${CMAKE_CURRENT_LIST_FILE} PATH)

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    if (KF_WERROR)
        set(WerrorFlag "-Werror")
    endif()
else()
    set(WerrorFlag "")
endif()

# Using C++20
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add compiler specific flags
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    add_compile_options(
        -Wall
        -fdiagnostics-color=always
        -Wextra
        -Wpedantic
        -Wconversion
        -Wunused
        -Wold-style-cast
        -Wpointer-arith
        -Wcast-qual
        -Wno-missing-braces
        ${WerrorFlag}
    )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    # Enable __VA_OPT__
    add_compile_options(
        /Zc:preprocessor
    )
    add_compile_definitions(
        NOMINMAX
    )
endif()

# Helper to add a submodule directory
function(add_submodule_directory SubmoduleDir)
    set(TESTS OFF)
    set(BENCHMARKS OFF)
    set(CODE_COVERAGE OFF)
    add_subdirectory(${SubmoduleDir})
endfunction()
