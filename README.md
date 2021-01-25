# Welcome to the Kube framework
Kube is a C++ framework that aims building efficient and stable cross-platform application for 2D and 3D rendering.

# What can I do with Kube ?
Kube was built with the idea of creating 3D voxel games, however, thanks to its modular architecture, the framework can be used only for either small and large 2D and 3D applications without paying the cost of what you don't need.

[Here is the documentation.](https://kube-engine.github.io/Kube/)


The goal of this framework is to establish a stable and powerful work environment for video-game development.

### Philosophy
The philosophy keywords of the framework are:
* Rigor: Each class is thinked for a long-term API support with latest technologies used right now and future technologies anticipated
* Explicitness: the codebase is as readable and as explicit as possible
* Data: Because of modern CPU weakness in memory IO, the best way to crank the speed up is though smart data modeling

## Modules
Kube framework is divided into modules that encapsulate specific parts of the engine.
|Name|Description|Version|Test Coverage|
|-|-|-|-|
|**Core**|Introduce low-level independent classes and language concepts to be used across the whole framework|0.0.3|![](https://byob.yarr.is/Kube-Engine/Kube/CoreCoverage)|
|**Flow**|A high frequency multithreading task scheduler|0.0.2|![](https://byob.yarr.is/Kube-Engine/Kube/FlowCoverage)|
|**Graphics**|Low level graphic engine|0.0.2|![](https://byob.yarr.is/Kube-Engine/Kube/GraphicsCoverage)|
|**Meta**|Implementation of non-intrusive runtime reflection with supports of signal / slots|0.0.3|![](https://byob.yarr.is/Kube-Engine/Kube/MetaCoverage)|
|**ECS**|An Entity Component System designed to fit in Flow's multithreaded task graph|0.0.2|![](https://byob.yarr.is/Kube-Engine/Kube/ECSCoverage)|
|**Object**|A high level base class used to bring reflection, signals and object-trees in any custom class|0.0.1|![](https://byob.yarr.is/Kube-Engine/Kube/ObjectCoverage)|
|**Interpreter**|Kube's language interpreter|WIP, early stage|![](https://byob.yarr.is/Kube-Engine/Kube/InterpreterCoverage)|
|**App**|Kube cross-platform window, inputs and events handling|WIP, early stage|![](https://byob.yarr.is/Kube-Engine/Kube/AppCoverage)|
|**UI**|A renderer optimized for 2D graphics|Not started yiet|![](https://byob.yarr.is/Kube-Engine/Kube/UICoverage)|
|**Voxel**|A graphics renderer optimized for voxel graphics|Not started yiet|![](https://byob.yarr.is/Kube-Engine/Kube/VoxelCoverage)|
|**Widgets**|High level objects used to abstract most common widgets for UI programming|Not started yiet|![](https://byob.yarr.is/Kube-Engine/Kube/WidgetsCoverage)|
|**Audio**|A 3D audio scene processor|Not started yiet|![](https://byob.yarr.is/Kube-Engine/Kube/AudioCoverage)|


## The Kube language
The Kube language can be seen like a remaster of the [QML language](https://doc.qt.io/qt-5/qtqml-index.html) language implemented in raw C++ for a much better code integration.

### Quick feature showcase
```qml
import kF.IO

import My.ObjectLib as My

Rectangle: background {
    // Register a function with both known and unknown
    function someFunc(var x, bool state): print(x, " -> ", state)

    // Special properties to position item relatively to parent
    relativeSize: 0.5, 0.5
    relativeCenterPos: 0.5, 0.5

    // Handle indirect events
    on ms.pressed: print("Pressed !")

    // Supports custom event
    on custom.someProperty == true: {
        print("Some property equals ", someProperty, " !"))
    }

    // Direct call to C++ custom constructor
    My.CustomObject("red", 34): custom {
        property bool someProperty: bool(false)
    }

    // Empty parenthesis are optionals when no arguments are needed
    MouseArea(): ms {
        anchors.fill: parent

        on released: {
            ++custom.customCounter // Direct C++ variable manipulation
            custom.someProperty = true // Sets interpreted property
            custom.doWork() // Direct call to C++ function
            background.someFunc("Hello", true); // Call to interpreted function
        }
    }
}
```

## Dependencies
The framework aims not to have unecessary dependencies
* C++ 20 for the meta-programming part
* [SDL2](https://www.libsdl.org/) for the window, user inputs and audio part
* [Vulkan](https://www.khronos.org/vulkan/) for GPU manipulation
* [Vulkan memory allocator](https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator) to allocate GPU memory


## More about Kube's background
If you want to know more about why and how this engine was created, please take a look at [this context page](https://github.com/Kube-Engine/Kube/blob/master/CONTEXT.md).