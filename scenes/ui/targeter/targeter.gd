extends Sprite2D

var target_pos: Vector2i = Vector2i.ZERO
var player_pos: Vector2i = Vector2i.ZERO

var line: PackedVector2Array


## this will hold each of the Sprite2D nodes
var line_path_grids: Array

@export var line_grid_texture: Texture2D


func _ready() -> void:

	target_pos = MapFunction.zoomed_in_mouse_pos
	player_pos = GameData.player.PositionComp.grid_pos

	update_visuals()



func _process(_delta: float) -> void:

	if !targeter_needs_to_be_seen():
		targeter_off()
		return
	else:
		targeter_on()

	if GameData.player.PlayerComp.is_in_world_map:
		if !needs_update_world_map():
			return
		target_pos = MapFunction.world_map_mouse_pos
		player_pos = GameData.player.PlayerComp.world_map_pos
	else:
		if !needs_update():
			return
		target_pos = MapFunction.zoomed_in_mouse_pos
		player_pos = GameData.player.PositionComp.grid_pos

	update_visuals()


func update_visuals() -> void:

	# set targeter's position
	global_position = MapFunction.to_world_pos(target_pos)
	

	if GameData.player.PlayerComp.is_in_world_map:
		make_path_line_world_map()
	else:
		make_path_line()

func make_path_line() -> void:

	reset_path_line()

	line = MapFunction.astar_get_path(player_pos, target_pos)

	# remove player's grid from path
	line.remove_at(0)

	for grid in line:

		var sprite = Sprite2D.new()
		sprite.z_index = 20
		sprite.z_as_relative = false
		sprite.texture = line_grid_texture
		sprite.global_position = MapFunction.to_world_pos(Vector2i(grid))
		line_path_grids.append(sprite)

		GameData.main_node.add_child(sprite)


func make_path_line_world_map() -> void:
	reset_path_line()


func reset_path_line() -> void:
	# remove old path line
	if !line_path_grids.is_empty():
		for sprite in line_path_grids:
			sprite.queue_free()

	line_path_grids = []

func needs_update_world_map() -> bool:
	if player_pos == GameData.player.PlayerComp.world_map_pos and target_pos == MapFunction.world_map_mouse_pos:
		return false

	return true

func needs_update() -> bool:
	if target_pos == MapFunction.zoomed_in_mouse_pos and player_pos == GameData.player.PositionComp.grid_pos:
		return false

	return true

func toggle_targeter() -> void:
	visible = !visible
	set_process(visible)

func targeter_needs_to_be_seen() -> bool:
	# check if targeter should be visible
	var input_mode = ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).input_mode
	if input_mode != GameData.INPUT_MODES.ZOOMED_IN_MOVEMENT and input_mode != GameData.INPUT_MODES.WORLD_MAP_MOVEMENT:
		return false

	return true


func targeter_off():
	visible = false
	reset_path_line()

func targeter_on():
	visible = true
	# reset_path_line()
	# update_visuals()
