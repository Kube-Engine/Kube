# Context
This section will explain the context and motivations behind the creation of the Kube framework.
We will take a tour of the different software development environments before concluding what this framework aims to be good at.
Please note that everything is **only my opinion** and my perception of the software engine market.

## Inspiration
After working for 3 years as a software architect, I was very used to [Qt Quick](https://doc.qt.io/qt-5/qtquick-index.html) and its [QML language](https://doc.qt.io/qt-5/qtqml-index.html) in my daily job. Qt is an awesome framework but have too many weakness on intrusiveness, performance and its wide range of ways to accomplish simple tasks.
After 3 attempts to re-create a Qt-Quick-like framework ([here is the last](https://github.com/MatthieuMv/openApp)) from scratch, I finally got the necessary metaprogramming, multithreading and data-oriented design skills to make a real-world framework using an interpreted language that would mix perfectly with C++.

# Types of software development environments

## Middle-level frameworks

These frameworks are often simple, efficient and allow you to control the architecture of your software.

### **SDL**, for 2D applications and games:
| Pros | Cons |
|-|-|
| Easy to learn and master | C code isn't safe but still easy to encapsulate |
| Lowest abstraction cost | You will have to code a lot more to get modern features |
| No specific IDE / editor | For 3D, you must deal with an API like OpenGL / Vulkan |
| You control the game architecture | |
| Very efficient | |
| You can code on anything that can compile C and run a text editor | |
| Runs on everything capable of 2D graphics on earth | |
| Good documentation and quality online contents | |

## High-level frameworks

These frameworks are often a huge collection of high-level systems and classes in order to make developper's job easier for any aspect of a software.

### **Qt Quick**, for 2D applications and games:
| Pros | Cons |
|-|-|
| Intuitive abstractions | Easy to mess, hard to master |
| Abstract most common parts of any software | Abstractions doesn't let much control to the user |
| You can code in your favorite setup since you can avoid QtCreator to compile | QtCreator is buggy and has a very poor user experience compared to VSCode |
| Can release for a very large variety of old and new devices | User is forced to adopt event driven development pattern for its architecture |
| QML is very good to manage user interface / inputs and non-critical event binding; it also allow a clear separation between front-end, middle-end and back-end | Gigabytes of libraries to download |
| Signal / Slot is a great pattern to expose functionalities of a class without adding dependencies (only for non-critical paths) | QML's JavaScript engine is very confusing when dealing with C++ code and classes |
| Best documentation and a lot of quality online contents | Few unexpected behaviors from an user perspective that slow you down |

## High level environments

These environments are often the combination of a framework and an editor. The framework tries to abstract as many features related to software / game development.

### **Unreal engine**, for 3D games only
| Pros | Cons |
|-|-|
| Good for beginners who wish to have quick results | Easy to mess, hard to master |
| Abstract most common parts of any 3D game | Very poor editor user experience: crashs, features poorly implemented (ex: global undo), a pain to get it running on linux and don't expect it to run on low-spec computers |
| Great cross-platform capabilities | You must use a lot of high-level / high-cost intrusive abstractions and have not much control over the architecture of your game |
| | Very bad for 2D graphics and UI design compared to SDL and Qt Quick |

# What to conclude ?

TODO