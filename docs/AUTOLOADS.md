# ECS HELPERS

## Component Registry
- **Path**: `res://autoload\ECS_helper\component_registry.gd`
- **Key variables**: -
- **Methods**: 
    - `init_weapon_components(weapon_node: Node2D, d: Dictionary) -> void`
        - initializes weapon item components

    - `get_component(entity: Node, component_key: int) -> Node`

    - `get_player_comp(component_key: int) -> Node`

    - `get_player_pos() -> Vector2i`
- **Notes**:
    - `Loads in data for custom made Gdoot Resources`

## Entity Systems
- **Path**: `res://autoload\ECS_helper\entity_systems.gd`
- **Key variables**:
    - `movement_system`: reference to movement Entity Component System
    - `combat_system`: reference to combat Entity Component System
    - `inentory_system`: reference to inventory Entity Component System
    - `entity_sapwner`: reference to Entity spawner system
- **Usage**:
    - `EntitySystems.movement_system to access MovementSystem class methods`
- **Notes**:
    - `Systems that handle ECS related stuff goes here`


# MAPS

## Map function
- **Path**: `res://autoload\maps\map_function.gd`
- **Methods**:
    - ***Misc***:
        - `asd`
        - `asd`
        - `asd`
        - `asd`
    - ***Checks***:
        - `asds`
- **Usage**:
    - `EntitySystems.movement_system to access MovementSystem class methods`
- **Notes**:
    - `Systems that handle ECS related stuff goes here`