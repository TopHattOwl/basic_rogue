class_name MonsterBase
extends Node2D
## base class for monsters, hold data that all type of monsters have
## for `d` Dictionary data templet see MonsterDefinitions

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
	make_components()
	fill_component_data(d)
	connect_signals()


func make_components() -> void:

	# position
	var pos_comp = PositionComponent.new()
	pos_comp.name = GameData.get_component_name(GameData.ComponentKeys.POSITION)
	components.add_child(pos_comp)


	# identity
	var identity_comp = IdentityComponent.new()
	identity_comp.name = GameData.get_component_name(GameData.ComponentKeys.IDENTITY)
	components.add_child(identity_comp)

	# health
	var health_comp = HealthComponent.new()
	health_comp.name = GameData.get_component_name(GameData.ComponentKeys.HEALTH)
	components.add_child(health_comp)

	# monster combat
	var monster_combat_comp = MonsterCombatComponent.new()
	monster_combat_comp.name = GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT)
	components.add_child(monster_combat_comp)

	# monster properties not used yet

	# defense stats
	var defense_stats_comp = DefenseStatsComponent.new()
	defense_stats_comp.name = GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS)
	components.add_child(defense_stats_comp)

	# attributes
	var attributes_comp = AttributesComponent.new()
	attributes_comp.name = GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES)
	components.add_child(attributes_comp)

	# ai behavior
	var ai_behavior_comp = AiBehaviorComponent.new()
	ai_behavior_comp.name = GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR)
	components.add_child(ai_behavior_comp)

	# modifiers
	var modifiers_comp = ModifiersComponent.new()
	modifiers_comp.name = GameData.get_component_name(GameData.ComponentKeys.MONSTER_MODIFIERS)
	components.add_child(modifiers_comp)


	# stamina
	# state
	# monster properties 
	# NOUT IMPLEMENTED


func fill_component_data(d: Dictionary) -> void:

	var d_final = calculate_stats(d)
	for comp in components.get_children():
		var comp_data = d_final.get(comp.name, {})
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
	
