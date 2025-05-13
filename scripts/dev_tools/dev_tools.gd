extends CanvasLayer


@onready var mouse_pos_label: Label = $Panel/VBoxContainer/MousePos
@onready var tile_info_layer: Label = $Panel/VBoxContainer/TileInfo
@onready var player_info_layer: Label = $Panel/VBoxContainer/PlayerInfo
@onready var actor_info_layer: Label = $Panel/VBoxContainer/EntityInfo


func _process(_delta: float) -> void:
	
	var player_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos
	
	# mouse info
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return
	var mouse_screen_pos = get_viewport().get_mouse_position()
	var mouse_world_pos = camera.get_screen_transform().affine_inverse() * mouse_screen_pos
	var mouse_grid_pos = MapFunction.to_grid_pos(mouse_world_pos) + player_pos + Vector2i(1,1)
	mouse_grid_pos.clamp(Vector2i(0,0), GameData.MAP_SIZE - Vector2i(1,1))


	# mouse info
	mouse_pos_label.text = "Mouse grid_pos: %s" % [mouse_grid_pos]


	# player info
	var player_hp = ComponentRegistry.get_player_comp(GameData.ComponentKeys.HEALTH).hp
	var player_max_hp = ComponentRegistry.get_player_comp(GameData.ComponentKeys.HEALTH).max_hp
	var player_world_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos
	player_info_layer.text = "Player HP: %s/%s\nPlayer pos: %s, world pos: %s" % [player_hp, player_max_hp, player_pos, player_world_pos]


	# actor info
	var actor = GameData.get_actor(mouse_grid_pos)
	actor_info_layer.text = "Actor: %s" % [actor]


	# tile info
	var tile_info = MapFunction.get_tile_info(mouse_grid_pos)
	if tile_info:
		tile_info_layer.text = update_tile_info(tile_info)

func update_tile_info(tile_info: Dictionary) -> String:
	var tags_string = ""
	for tag in tile_info.tags:
		match tag:
			GameData.TILE_TAGS.NONE:
				tags_string += "None, "
			GameData.TILE_TAGS.FLOOR:
				tags_string += "Floor, "
			GameData.TILE_TAGS.WALL:
				tags_string += "Wall, "
			GameData.TILE_TAGS.STAIR:
				tags_string += "Stair, "
			GameData.TILE_TAGS.DOOR:
				tags_string += "Door, "
			GameData.TILE_TAGS.DOOR_FRAME:
				tags_string += "Door frame, "
			GameData.TILE_TAGS.NATURE:
				tags_string += "Nature, "
	var walkable_string = "Walkable" if tile_info.walkable else "Not walkable"
	var transparent_string = "Transparent" if tile_info.transparent else "Not transparent"

	return "Tile info: %s, %s, %s" % [tags_string, walkable_string, transparent_string]

func toggle_dev_overlay():
	if visible:
		visible = false
	else:
		visible = true
