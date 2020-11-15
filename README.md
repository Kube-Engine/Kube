# Welcome to the Kube framework
Kube framework is a cross-platform C++

[Here is the documentation.](https://kube-engine.github.io/Kube/)

## Context
This framework has been created to prepare an incoming game studio.
The goal of this framework is to establish a stable and powerful work environment for video-game development.

### Philosophy
The philosophy keywords of the framework are:
* Rigor: Each class is thinked for a long-term API support with latest technologies used right now and future technologies anticipated
* Explicitness: the codebase is as readable and as explicit as possible
* Data: Because of modern CPU weakness in memory IO, the best way to crank the speed up is though smart data modeling

### Inspiration
After working for 3 years as a software architect, I was very used to [Qt Quick](https://doc.qt.io/qt-5/qtquick-index.html) and its [QML language](https://doc.qt.io/qt-5/qtqml-index.html) in my daily job. Qt is an awesome framework but have too many weakness on intrusiveness, performance and its wide range of ways to accomplish simple tasks.
After 3 attempts to re-create a Qt-Quick-like framework ([here is the last](https://github.com/MatthieuMv/openApp)) from scratch, I finally got the necessary metaprogramming and  skills to make a real-world interpreted language that would mix perfectly with C++.

## Modules
Kube framework is divided into modules that encapsulate specific parts of the engine.
|Name|Description|Version|
|-|-|-|
|**Core**|Contains over-optimized basic classes used in multiples modules|0.2
|**Meta**|Implementation of non-intrusive runtime reflection with supports of signal / slots|0.2
|**Flow**|A high frequency multithreading task scheduler|0.1
|**ECS**|An Entity Component System designed to fit in Flow's multithreaded task graph|0.1
|**Interpreter**|Kube's language interpreter|WIP, early stage
|**App**|Kube cross-platform window, inputs and events handling|WIP, early stage
|**Graphics**|Low level graphic engine|0.1
|**Voxel**|A renderer optimized for voxel graphics|Not started yiet
|**Audio**|A 3D audio scene processor|Not started yiet

## The Kube language
The Kube language can be seen like a remaster of the [QML language](https://doc.qt.io/qt-5/qtqml-index.html) language implemented in raw C++ for a much better code integration.

### Quick feature showcase
```qml
import kF.IO

import My.ObjectLib as My

Rectangle {
    // Register a function with both known and unknown
    function someFunc(var x, bool state): print(x, " -> ", state)

    id: background

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
    My.CustomObject("red", 34) {
        property bool someProperty: bool(false)

        id: custom
    }

    // Empty parenthesis are optionals when no arguments are needed
    MouseArea() {
        id: ms
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
* SDL2 for the window, user inputs and audio part
* Vulkan

