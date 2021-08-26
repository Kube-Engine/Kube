function Show-Help {
    Write-host "USAGE: .\buildWindows.ps1 [arg0, ..., argN]
    release:        Build in release mode (default)
    debug:          Build in debug mode
    tests:          Enable unit testing
    benchmarks:     Enable benchmarking
    clean:          Delete all build directories
    fclean:         Alias of the 'clean' command
    core:           Mark 'Core' module for manual build
    audio:          Mark 'Audio' module for manual build
    graphics:       Mark 'Graphics' module for manual build
    meta:           Mark 'Meta' module for manual build
    flow:           Mark 'Flow' module for manual build
    ecs:            Mark 'ECS' module for manual build
    object:         Mark 'Object' module for manual build
    interpreter:    Mark 'Interpreter' module for manual build
    voxel:          Mark 'Voxel' module for manual build
    ui:             Mark 'UI' module for manual build
    widgets:        Mark 'Widgets' module for manual build
    app:            Mark 'App' module for manual build
    "
    Exit
}

function Clean-Build {
    if (Test-Path $buildDir) {
        Remove-Item $buildDir -Recurse -Force
    }
    Exit

}

$buildType = "Release"
$buildTests = $false
$buildBenchmarks = $false
$cmakeArgs = ""
$buildDir = "Build"

switch ($args) {
    'release'       { $buildType = "Release" }
    'debug'         { $buildType = "Debug" }
    'tests'         { $buildTests = $true }
    'benchmarks'    { $buildBenchmarks = $true }
    'clean'         { Clean-Build }
    'fclean'        { Clean-Build }
    "--help"        { Show-Help }
    "core"          { $cmakeArgs += " -DKF_CORE=ON" }
    "audio"         { $cmakeArgs += " -DKF_AUDIO=ON" }
    "graphics"      { $cmakeArgs += " -DKF_GRAPHICS=ON" }
    "meta"          { $cmakeArgs += " -DKF_META=ON" }
    "flow"          { $cmakeArgs += " -DKF_FLOW=ON" }
    "ecs"           { $cmakeArgs += " -DKF_ECS=ON" }
    "object"        { $cmakeArgs += " -DKF_OBJECT=ON" }
    "interpreter"   { $cmakeArgs += " -DKF_INTERPRETER=ON" }
    "voxel"         { $cmakeArgs += " -DKF_VOXEL=ON" }
    "ui"            { $cmakeArgs += " -DKF_UI=ON" }
    "widgets"       { $cmakeArgs += " -DKF_WIDGETS=ON" }
    "app"           { $cmakeArgs += " -DKF_APP=ON" }
    default         {
        Write-host "Invalid argument, please use --help for usage"
        Exit
    }
}

$messagePrefix = "[$buildType"
if ($buildTests) {
    $messagePrefix = "$messagePrefix, Tests"
    $cmakeArgs += " -DKF_TESTS=ON"
}
if ($buildBenchmarks) {
    $messagePrefix = "$messagePrefix, Benchmarks"
    $cmakeArgs += " -DKF_BENCHMARKS=ON"
}
$messagePrefix = "$messagePrefix]"

Write-host "$messagePrefix Creating build directory... ($cmakeArgs)"
Invoke-Expression "cmake -E make_directory $buildDir"
if ($?) {
    Write-host "$messagePrefix Creating build directory - Success"
} else {
    Write-host "$messagePrefix Creating build directory - Failure"
    Exit
}

Write-host "$messagePrefix Executing CMake..."
Invoke-Expression "cmake -B $buildDir $cmakeArgs ."
if ($?) {
    Write-host "$messagePrefix Executing CMake - Success"
} else {
    Write-host "$messagePrefix Executing CMake - Failure"
    Exit
}

Write-host "$messagePrefix Building..."
Invoke-Expression "cmake --build $buildDir --config $buildType"
if ($?) {
    Write-host "$messagePrefix Building - Success"
} else {
    Write-host "$messagePrefix Building - Failure"
    Exit
}
