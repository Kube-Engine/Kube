# Non-exhaustive list of things to do in the engine

## Core

### Tiny Vector
The tiny vector is a vector of 16 bytes using 32 bits unsigned integers as size / capacity
This vector is used when memory constraints are high but we need to retreive size without dereferencing the data (opposed to FlatVector)


## Meta

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