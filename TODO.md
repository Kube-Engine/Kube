# Non-exhaustive list of things to do in the engine

## Meta

### Type system
We can reduce type look-up time by having a second vector holding each index or name of all registered types so we lookup on a flat vector instead of dereferencing each type descriptor.

### Type specific static variables
We must implement runtime static variables to every meta type.

### Enums
We must implement enum registeration.

## Flow

### Tasking API
The API proposes a DynamicNode to generate on runtime tasks during the graph execution. This node is not implemented.
