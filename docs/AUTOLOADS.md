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
        - `to_world_pos(pos: Vector2i) -> Vector2`
            - turns grid position to float position to use for Node.position
        - `to_grid_pos(pos: Vector2) -> Vector2i`
            - turns Node's position to grid pos
    - ***Checks***:
        - `is_tile_walkable(pos: Vector2i) -> bool`
            - checks if tile is walkable on zoomed in map
        - `is_in_bounds(pos: Vector2i) -> bool`
            - checks ifa tile is inside zoomed in map
    - ***Getters***:
        - `chebyshev_distance(a: Vector2i, b: Vector2i) -> int`
            - calculates the distance between 2 position, using chebyshev method (counts steps like he king in chess, diagonal and orthogonal moves are the same distance)
        - `manhattan_distance(a: Vector2i, b: Vector2i) -> int`
            - calculates the distance between 2 position, using manhattan method (only otrhogonal moves)
        - `get_actor(grid_pos: Vector2i) -> Node2D`
            - returns the actor's Node reference at given grid pos
        - `get_items(grid_pos: Vector2i) -> Array`
            - returns the actor's Node reference at given grid pos
        - `get_tile_info(grid_pos: Vector2i) -> Dictionary`
            - returns terrain_map's value at given grid position
    - ***Map Data***:
        - `initialize_map_data()`
            - initializes terrain_map, actors_map and items_map inside GameData autoload (makes 2d arrays filled with null, and floor type for terrain_map)
        - `add_terrain_map_data(target_pos: Vector2i, tag: int, tile_info: Dictionary) -> void`
            - adds given tag to a terrain_map.tags and sets most restrictive peroperties for walkable and transparent
        - `parse_tile_layers_from_scene(map_root: Node2D) -> void`
            - parses tile layers from a premade map and load them inot GameData.terrain_map
            - initializes A* grid
    - ***Tilesets***:
        - `is_tile_walkable(pos: Vector2i) -> bool`
            - checks if tile is walkable on zoomed in map
        - `is_in_bounds(pos: Vector2i) -> bool`
            - checks ifa tile is inside zoomed in map
    - ***AStar***:
        - `is_tile_walkable(pos: Vector2i) -> bool`
            - checks if tile is walkable on zoomed in map
        - `is_in_bounds(pos: Vector2i) -> bool`
            - checks ifa tile is inside zoomed in map
    - ***Map loading***:

    - ***Transition***:
    - ***World Map***:
    - ***Constructors***:
- **Usage**:
    - `EntitySystems.movement_system to access MovementSystem class methods`
- **Notes**:
    - `Systems that handle ECS related stuff goes here`