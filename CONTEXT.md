## Context
This section will explain the context and motivations behind the creation of the Kube framework.
Please note that everything is **only my opinion** and my perception of the software engine market.

First, I'll share my experience with few development environments in order to understand the different types of options available.

## Middle-level frameworks

These frameworks are often simple, efficient and allow you to control the architecture of your software.

### **SDL**, for 2D applications and games:
| Pros | Warning | Cons |
|-|-|-|
| Good for beginners and advanced programmers: easy to learn, easy to master | C code is old and not safe but encapsulation is very easy | You code more |
| Build highly efficient 2D application | | For 3D, you must deal with an API like OpenGL / Vulkan which are way harder to learn and master) |
| You control the game architecture | | |
| No specific IDE required | | |
| Run on anything | | |
| You don't have to understand everthing (even if you can easily) to get great performances | | |

## High-level frameworks

These frameworks are often a huge collection of high-level systems and classes

### **Qt Quick**, for 2D applications and games:
| Pros | Warning | Cons |
|-|-|-|
| Great to design decent applications *quickly* when you master it: you will encounter so many unexpected behavior from a user perspective that the great productivity Qt Quick has on paper is not so quick in practise | Easy to learn, hard to master | You must understand Qt's back-end concepts to make efficient applications |
| Intuitive abstractions | Qt creator simplifies development but is not as good as VS Code in coding experience, however, you still can compile easily by hand and use another IDE | For 3D, Qt is way behind other engines like Unreal Engine but you can easily integrate OpenGL / Vulkan code |
| The documentation is very rich and detailed |  | QML's JavaScript engine is very confusing when dealing with C++ code and classes |
| Signal / Slot is a great but non optimal way to expose functionalities of a class without adding dependencies | | Signals are abused in Qt: they are everywhere and sometimes you really lack an optimal pattern for a high workload |
| QML philosophy, as a declarative language, is very good for user interface / inputs and non-critical event binding; it also allow a clear separation between front-end (qml), middle-end (QObject / Q... derived) and back-end (non Qt-derived) |
| | | The framework is very big in memory space |
## High level engines
### **Unreal engine**, for 3D ~~FPS~~ games
| Pros | Warning | Cons |
|-|-|-|
| Good for a beginner who doesn't code | A lot of community guide and tutorials of poor educational quality | Poor documentation compared to Qt |
| Very good to quickly make FPS / TPS games, with a simple **technical** gameplay architecture (like Fortnite) | | Crazy high-level abstractions overhead |
| There is an abstraction for every aspect of a ~~shooter~~ game | | The worse team working capabilities: very bad github integration due to the fact that most files are non-human readable |
| Most easiest way to get and play around with good graphics | | The worse editor: it often crash (for example when deleting a file), it has some counter-intuitive features like a global undo / redo instead of per file; you must re-open the editor each time you want to compile C++ code, which is terrible given the fact that if you don't have a very high-end CPU, it can take few minutes; it also has a terrible linux integration and wasn't stable enough to be usable on my i7-7500U integrated graphics laptop. |
| | | Not good at all for 2D graphics  |



# What to conclude ?
