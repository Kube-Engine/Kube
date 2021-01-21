# Non-exhaustive list of things to do in the engine

## Object
Proxy for structures that doesn't need
Better use a single signal for multiple data, ex: (x, y, w, h)
    -> reduce signal explosion

## KML
Each property / function is not stored in the object but as a form of a temporary expression that is inlined where used
A function is an syntaxic sugar for an expression with local variables

## Core

## Allocator functor
Make allocator for functors such as they are passed either at emplace (destructor is guessed and stored perfectly !)

### Allocator vectors
Make allocator vectors

### Vector shrink
Add vector shrink function && add shrink in meta registerer

## Meta

### STATIC STORAGE !
We MUST test static storage though different translation units

### Type system
We can reduce type look-up time by having a second vector holding each index or name of all registered types so we lookup on a flat vector instead of dereferencing each type descriptor.

### Type specific static variables
We must implement runtime static variables to every meta type.

### Enums
We must implement enum registeration.


## Flow

### Tasking API
The API proposes a DynamicNode to generate on runtime tasks during the graph execution, this node is not implemented.
We must have a way to bypass node of a graph if a flag is set