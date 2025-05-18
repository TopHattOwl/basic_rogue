extends Node

var player_ui: CanvasLayer

func set_player_ui():
	player_ui = GameData.player.get_node("PlayerUI")
	print("player ui set: ", player_ui)

func log_message(text: String) -> void:
	player_ui.log_message(text)

func toggle_look_ui() -> void:
	player_ui.toggle_look_ui()

func set_look_ui_texture(texture: Texture2D) -> void:
	player_ui.set_look_ui_texture(texture)

func update_look_ui(grid_pos: Vector2i) -> void:
	player_ui.update_look_ui(grid_pos)

## makes an array of all the things player can look at, at a given position
func set_look_ui_target_array(grid_pos: Vector2i) -> void:

	var actor = MapFunction.get_actor(grid_pos)
	var items = MapFunction.get_items(grid_pos)
	var tile_map_layers = MapFunction.get_tile_map_layers(grid_pos)
	var terrain_data = MapFunction.get_tile_info(grid_pos)

	var look_target_stuff = []

	# ACTOR
	if actor:
		var actor_name = ComponentRegistry.get_component(actor, GameData.ComponentKeys.IDENTITY).actor_name
		look_target_stuff.append(make_look_target_entry(actor.get_node("Sprite2D").texture, actor_name, actor_name))

	# ITEMS

	if items:
		for item in items:
			var item_name = ComponentRegistry.get_component(item, GameData.ComponentKeys.ITEM_IDENTITY).item_name
			look_target_stuff.append(make_look_target_entry(item.get_node("Sprite2D").texture, item_name, item_name))

	# TERRAIN
	# TODO: loop tru terrain_data.tags and add all terrains
	var terrain_stuff = []
	# if it has wall the only thing the player can see is wall
	if tile_map_layers.keys().has(GameData.TILE_TAGS.WALL):

		# get the name (matchin source id of the tile) see TileMapLayer Node's TileSet resource
		var terrain_name = ""
		match tile_map_layers[GameData.TILE_TAGS.WALL].get_cell_source_id(grid_pos):
			0:
				terrain_name = "wooden wall"
			1:
				terrain_name = "stone wall" # stone wall tleset source not yet added

		terrain_stuff.append(make_look_target_entry(
			MapFunction.get_tile_texture(tile_map_layers[GameData.TILE_TAGS.WALL], grid_pos),
			terrain_name,
			"a wall"
		))
	else:
		# tile_map_layers.keys().has(GameData.TILE_TAGS.FLOOR):

		# get the name (matchin source id of the tile) see TileMapLayer Node's TileSet resource
		var terrain_name = ""
		match tile_map_layers[GameData.TILE_TAGS.FLOOR].get_cell_source_id(grid_pos):
			0:
				terrain_name = "ground"
			1:
				terrain_name = "wooden floor" # stone floor tleset source not yet added

		terrain_stuff.append(make_look_target_entry(
			MapFunction.get_tile_texture(tile_map_layers[GameData.TILE_TAGS.FLOOR], grid_pos),
			terrain_name,
			"a floor"
		))

	look_target_stuff.append_array(terrain_stuff)


	player_ui.look_target_stuff = look_target_stuff


	# update the look ui
	update_look_ui(grid_pos)

func make_look_target_entry(texture: Texture2D, description: String, target_name: String):
	return {
		"texture": texture,
		"description": description,
		"name": target_name
	}



# --- PLAYER CAMERA ---

func set_camera_limits():
	if !ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map:
		GameData.player.get_node("Camera2D").limit_right = (GameData.MAP_SIZE.x + 3)  * GameData.TILE_SIZE.x
		GameData.player.get_node("Camera2D").limit_bottom = (GameData.MAP_SIZE.y + 2) * GameData.TILE_SIZE.y
		GameData.player.get_node("Camera2D").limit_top = (-3) * GameData.TILE_SIZE.y
		GameData.player.get_node("Camera2D").limit_left = (-2) * GameData.TILE_SIZE.x
	else:
		GameData.player.get_node("Camera2D").limit_right = GameData.WORLD_MAP_SIZE.x * GameData.TILE_SIZE.x
		GameData.player.get_node("Camera2D").limit_bottom = GameData.WORLD_MAP_SIZE.y * GameData.TILE_SIZE.y
		GameData.player.get_node("Camera2D").limit_top = 0
		GameData.player.get_node("Camera2D").limit_left = 0


func update_camera_data():
	var cam = GameData.player.get_node("Camera2D")
	if !ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map:
		# limits
		cam.limit_right = (GameData.MAP_SIZE.x + 14)  * GameData.TILE_SIZE.x
		cam.limit_bottom = (GameData.MAP_SIZE.y + 2) * GameData.TILE_SIZE.y
		cam.limit_top = (-3) * GameData.TILE_SIZE.y
		cam.limit_left = (-10) * GameData.TILE_SIZE.x

		# zoom 
		cam.zoom = Vector2(0.65, 0.65)

		# set offset
		cam.offset.x = 100
	else:
		cam.limit_right = GameData.WORLD_MAP_SIZE.x * GameData.TILE_SIZE.x
		cam.limit_bottom = GameData.WORLD_MAP_SIZE.y * GameData.TILE_SIZE.y
		cam.limit_top = 0
		cam.limit_left = 0

		cam.zoom = Vector2(0.4, 0.4)

		cam.offset.x = 0
