class_name NPCBase
extends Node2D

var sprite: Sprite2D

var components: Node

var id: int
var uid: String



func _ready() -> void:
	pass


func get_component(component_key: int) -> Node:
	if not components.has_node(GameData.get_component_name(component_key)):
		return null

	var comp = get_node("Components").get_node(GameData.get_component_name(component_key))
	return comp


func _init(d: Dictionary) -> void:
	components = Node.new()
	components.name = "Components"
	add_child(components)

	var base_data = d.get("base_data", {}) # base values (uid, id, etc.)
	set_base_data(base_data)

	add_components(d)


func add_components(d: Dictionary) -> void:
	make_components(d)
	fill_component_data(d)


func set_base_data(data: Dictionary) -> void:
	id = data.get("id", 0)
	uid = data.get("uid", "")

	# sprite
	var texture
	if not DirectoryPaths.npc_sprites[id]:
		var placeholder = PlaceholderTexture2D.new()
		placeholder.size = GameData.TILE_SIZE
		texture = placeholder
	else:
		texture = load(DirectoryPaths.npc_sprites[id])
	var _sprite = Sprite2D.new()
	_sprite.name = "Sprite2D"
	_sprite.texture = texture
	sprite = _sprite

	z_index = 15
	z_as_relative = false

	add_child(sprite)


func make_components(d: Dictionary) -> void:
	

	# make all the components the npc has that are in NpcDefinitions
	for key in d:
		if key == "base_data":
			continue
		
		var comp_name: String = key
		if DirectoryPaths.component_paths.has(comp_name):
			var component = load(DirectoryPaths.component_paths[comp_name]).new()
			component.name = comp_name
			components.add_child(component)
		else:
			push_error("Component not found: ", comp_name)


	# var talk_data_path = d.get(GameData.get_component_name(GameData.ComponentKeys.TALK), {}).get("conversation_tree_json_path", "")
	# if not talk_data_path:
	# 	push_error("Missing talk data path for npc: ", uid)
	# var talk_data_json: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(talk_data_path))
	# print(talk_data_json)

	# # make components from talk data
	# for key in d:
	# 	if key == "base_data":
	# 		continue
		
	# 	var comp_name: String = key
	# 	if DirectoryPaths.component_paths.has(comp_name):
	# 		var component = load(DirectoryPaths.component_paths[comp_name]).new()
	# 		component.name = comp_name
	# 		components.add_child(component)
	# 	else:
	# 		push_error("Component not found: ", comp_name)


func fill_component_data(d: Dictionary):

	var d_final = d
	for comp in components.get_children():
		var comp_data = d_final.get(comp.name, {})
		if not comp.has_method("initialize"):
			continue
		comp.initialize(comp_data)
