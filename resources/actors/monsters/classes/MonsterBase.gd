class_name MonsterBase
extends Node2D
## base class for monsters, hold data that all type of monsters have
## for `d` Dictionary data template see MonsterDefinitions

var sprite: Sprite2D

var components: Node # parent node that will hold component Nodes

# easy access to important stuff
var id: int
var uid: String

# for monster managers to spawn(AmbushManager and DungeonManager)
var cost: int
var monster_group: int



# COLOR
var text_color: String

func _ready() -> void:
	pass

func on_death() -> void:
	drop_loot()

func drop_loot() -> void:
	var monster_drops_comp: MonsterDropsComponent = get_component(GameData.ComponentKeys.MONSTER_DROPS)
	var loot = monster_drops_comp._roll_for_drops()

	if loot.is_empty():
		return
	
	var pos_comp: PositionComponent = get_component(GameData.ComponentKeys.POSITION)
	var grid_pos: Vector2i = pos_comp.grid_pos  
	for item_id in loot:
		var item: ItemResource = ItemFactory.create_item(item_id)
		ItemDropManager.drop_item(item, grid_pos)

func get_component(component_key: int) -> Node:
	return get_node("Components").get_node(GameData.get_component_name(component_key))


func connect_signals() -> void:
	SignalBus.fov_calculated.connect(_on_fov_calculated)


func _init(d: Dictionary) -> void:
	components = Node.new()
	components.name = "Components"
	add_child(components)

	var base_data = d.get("base_data", {}) # base values (id, ui, cost, etc.)
	set_base_data(base_data)

	add_components(d)

func set_base_data(d: Dictionary) -> void:
	id = d.get("id", 0)
	uid = d.get("uid", "")
	cost = d.get("cost", 0)
	monster_group = d.get("monster_group", 0)
	text_color = d.get("text_color", "#dfdfdf")

	# sprite
	var texture
	if not DirectoryPaths.monster_sprites[id]:
		var placeholder = PlaceholderTexture2D.new()
		placeholder.size = GameData.TILE_SIZE
		texture = placeholder
	else:
		texture = load(DirectoryPaths.monster_sprites[id])
	var _sprite = Sprite2D.new()
	_sprite.name = "Sprite2D"
	_sprite.texture = texture
	sprite = _sprite

	z_index = 15
	z_as_relative = false


	# add child nodes
	add_child(sprite)
	

func add_components(d: Dictionary) -> void:
	make_components(d)
	fill_component_data(d)
	connect_signals()


func make_components(d: Dictionary) -> void:

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


func fill_component_data(d: Dictionary) -> void:

	var d_final = calculate_stats(d)
	for comp in components.get_children():
		var comp_data = d_final.get(comp.name, {})
		if not comp.has_method("initialize"):
			continue
		comp.initialize(comp_data)


func calculate_stats(_d: Dictionary) -> Dictionary:
	var d = _d

	var monster_combat_comp = d.get(GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT), {})
	var health_comp = d.get(GameData.get_component_name(GameData.ComponentKeys.HEALTH), {})

	var monster_stats = {
		"monster_combat_component": monster_combat_comp,
		"health_component": health_comp,
	}
	TimeDifficulty.calc_monster_stats(monster_stats)

	return d

# SINGALS


func _on_fov_calculated() -> void:

	var monster_pos = get_component(GameData.ComponentKeys.POSITION).grid_pos

	if monster_pos in FovManager.visible_tiles:
		visible = true
	else:
		visible = false
	
