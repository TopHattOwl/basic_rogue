extends Node

var player_ui: CanvasLayer

func _ready() -> void:
	SignalBus.player_acted.connect(_on_pass_time)
	SignalBus.block_power_changed.connect(_block_test)
	SignalBus.actor_hit_final.connect(_log_actor_hit)
	SignalBus.skill_leveled_up.connect(_log_skill_level_up)

func _block_test(new_value, max_value):
	player_ui.update_block_display(new_value, max_value)

func _on_pass_time():
	log_message("<<<<< --- Turn Ended --- >>>>>")

func set_player_ui():
	player_ui = GameData.player.get_node("PlayerUI")
	print("player ui set: ", player_ui)


# --- MESSAGE LOG ---

func _log_actor_hit(hit_data: Dictionary) -> void:
	var target = hit_data.target
	var attacker = hit_data.attacker
	var damage = hit_data.damage
	var hit_action = hit_data.hit_action

	if attacker == GameData.player:
		log_player_attack(target, damage, hit_data.element, hit_action)
	elif attacker.is_in_group("monsters"):
		log_monster_attack(attacker, damage, hit_action)

# logs generic message
func log_message(text: String) -> void:
	player_ui.log_message(text)

## logs monster attack if target is player, `param` hit_action: 0 -> hit, 1 -> miss, 2 -> player blocked
func log_monster_attack(monster: Node2D, damage: int, hit_action: int = 0) -> void:
	player_ui.log_message(LogMessage.make_monster_attack_message(monster, damage, hit_action))

## logs player attack, `param` hit_action: 0 -> hit, 1 -> miss, 2 -> blocked
func log_player_attack(target: Node2D, damage: int, element: int, hit_action: int = 0) -> void:
	player_ui.log_message(LogMessage.make_player_attack_message(target, damage, element, hit_action))


func _log_skill_level_up(skill_tree_id: int) -> void:
	var skill_tree = GameData.player.SkillsComp.skills[skill_tree_id]
	print("skill leveled up: ", skill_tree.skill_tree_name, " level: ", skill_tree.level)

	player_ui.log_message(LogMessage.make_skill_level_up_message(skill_tree_id))

# --- LOOK UI ---
func toggle_look_ui() -> void:
	player_ui.toggle_look_ui()

func set_look_ui_texture(texture: Texture2D) -> void:
	player_ui.set_look_ui_texture(texture)

func update_look_ui(grid_pos: Vector2i) -> void:
	player_ui.update_look_ui(grid_pos)

## makes an array of all the things player can look at, at a given position
func set_look_ui_target_array(grid_pos: Vector2i) -> void:

	var actor = MapFunction.get_actor(grid_pos)
	var _items = MapFunction.get_items(grid_pos)
	var tile_map_layers = MapFunction.get_tile_map_layers(grid_pos)
	var _terrain_data = MapFunction.get_tile_info(grid_pos)

	var look_target_stuff = []

	# ACTOR
	if actor:
		var actor_name = ComponentRegistry.get_component(actor, GameData.ComponentKeys.IDENTITY).actor_name
		look_target_stuff.append(make_look_target_entry(actor.get_node("Sprite2D").texture, actor_name, actor_name))

	# # ITEMS

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

## Updates player camera limit, zoom and offset based where player is (world map, dungon, etc.)
func update_camera_data():
	var cam = GameData.player.get_node("Camera2D")

	# zoomed in or dungeon
	if !ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map:
		# limits
		# todo fix
		cam.limit_right = (GameData.MAP_SIZE.x + 8)  * GameData.TILE_SIZE.x
		cam.limit_bottom = (GameData.MAP_SIZE.y + 3) * GameData.TILE_SIZE.y
		cam.limit_top = (-3) * GameData.TILE_SIZE.y
		cam.limit_left = (-13) * GameData.TILE_SIZE.x

		# zoom 
		cam.zoom = Vector2(0.7, 0.7)

		# set offset
		cam.offset.x = 64
	
	# world map
	elif ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map and !GameData.player.PlayerComp.is_in_dungeon:
		cam.limit_right = GameData.WORLD_MAP_SIZE.x * GameData.TILE_SIZE.x
		cam.limit_bottom = GameData.WORLD_MAP_SIZE.y * GameData.TILE_SIZE.y
		cam.limit_top = 0
		cam.limit_left = 0

		cam.zoom = Vector2(0.4, 0.4)

		cam.offset.x = 0


# --- STANCE BAR ---

# calls stance_bar.gd's toggle_stance_bar, 
func toggle_stance_bar():
	player_ui.stance_bar.toggle_stance_bar()


# --- INVENTORY ---

func toggle_inventory():
	player_ui.inventory.toggle_inventory()

# --- SIDEBAR ---

func toggle_sidebar():
	player_ui.visible = !player_ui.visible
