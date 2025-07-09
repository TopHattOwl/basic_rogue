class_name MonsterBase
extends Node2D
## base class for monsters, hold data that all type of monsters have

var sprite: Sprite2D

var components: Node # parent node that will hold component Nodes

# easy access to important stuff
var id: int
var uid: String

# for monster managers to spawn(AmbushManager and DungeonManager)
var cost: int
var biome_weights: Dictionary
var monster_group: int

func _ready() -> void:
	pass


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
	biome_weights = d.get("biome_weights", {})
	monster_group = d.get("monster_group", 0)

	# sprite
	# var texture = PlaceholderTexture2D.new()
	var texture = load(DirectoryPaths.monster_sprites[id])
	# texture.size = Vector2(16, 24)
	var _sprite = Sprite2D.new()
	_sprite.texture = texture
	sprite = _sprite

	z_index = 15
	z_as_relative = false


	# add child nodes
	add_child(sprite)
	

func add_components(d: Dictionary) -> void:
	make_components(d)
	# var pos_comp = PositionComponent.new()
	# pos_comp.grid_pos = Vector2i.ZERO
	# pos_comp.name = GameData.get_component_name(GameData.ComponentKeys.POSITION)
	# components.add_child(pos_comp)


func make_components(d: Dictionary) -> void:
	pass

	

	

