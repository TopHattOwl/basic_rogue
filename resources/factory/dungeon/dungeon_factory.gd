class_name DungeonFactory
extends Node


static func make_dungeon(data: Dictionary, class_type: Variant) -> Dungeon:
	var _dungeon = class_type.new(data)


	# add it to world map data
	WorldMapData.dungeons.add_dungeon(_dungeon)
	WorldMapData.world_monster_map.add_dungeon(_dungeon.world_map_pos, _dungeon.id)

	return _dungeon
