class_name TowerDungeon
extends Dungeon


func make_levels() -> void:

	var dungeon_levels = rng.randi_range(2, 4)

	for level in dungeon_levels:
		levels.append(TowerDungeonLevel.new())
		levels[level].generate_dugeon_level(level, world_map_pos)


func set_draw_data() -> void:
	tileset_resource = DrawDatas.dungeon_tileset_resource[GameData.DUNGEON_TYPES.TOWER]
	tile_set_draw_data = DrawDatas.dungeon_tileset_draw_data[GameData.DUNGEON_TYPES.TOWER]