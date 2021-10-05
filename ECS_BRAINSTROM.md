# ECS

Entities

Components

Systems
They own instances of components registered though ComponentStorage meta-interface.
This interface allow serveral implementation of a component storage to optimize on each use case.

A ComponentStorage can be made either from combination of:

1) A sparse set containing entities and another array that store a single type of component
    + Fast entity iteration
    + Fast single component type iteration
    - Slow multiple components types iteration
    - Slow single component type lookup
    - Slow multiple components types lookup

2) A sparse set containing entities and another array that store a multiple types of components
    + Fast entity iteration
    - Slow single component type iteration
    - Slow multiple components types iteration
    - Slow single component type lookup
    + Fast multiple components types lookup

3) A sparse set containing entities and component a single type of component
    - Slow entity iteration
    - Slow single component type iteration
    - Slow multiple components types iteration
    + Fast single component type lookup
    - Slow multiple components types lookup

4) A sparse set containing entities and multiple types of components
    - Slow entity iteration
    - Slow single component type iteration
    - Slow multiple components types iteration
    + Fast single component type lookup
    + Fast multiple components types lookup