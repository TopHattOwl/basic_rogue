class_name MapGenerator
extends Node


# genrates random surface map

# generation steps:
    # init with all floor tile (each tile is random from given tileset)
    # generate map data matching biome type
    # generate monster related stuff based on savagery and world map monster data
    # make it usable for world Node (load into the tile map layer Nodes)
    # make copy of world Node and set it to current map
    # set variables
    # add as a child into main node


## Generates random map, sets variables
func generate_random_map(world_map_pos: Vector2i) -> void:
    print("generating random map at pos: ", world_map_pos)
    var terrain_map = MapFunction.make_base_terrain_map()





    