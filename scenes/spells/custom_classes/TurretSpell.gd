class_name TurretSpell
extends SpellNode
## turret spells spawn down a slow moving spell that stops one tile before the first obstacle 
## slow moving, high capacity cost
## the turret spell hits enemies with it's own spells like a lighning ball that zaps enemies


@export var animated_sprite: AnimatedSprite2D

var distance_traveled: int

var full_path: PackedVector2Array

## base damage used for turret spell projectile's damage calculation
## calculated from melee combat component's damage calculation, modifiers applied
var base_damage: int

func _ready() -> void:
	if debug:
		print("turret spell ready")
	SignalBus.projectile_spawned.emit({
		"spell": self
	})
	distance_traveled = 0

	animated_sprite.play()

func _process(_delta: float) -> void:
	check_grid(current_grid)

func process_turn() -> void:
	if debug:
		print("spell moving")
	check_spell_path()


func cast_spell(_caster: Node2D, _target_grid: Vector2i) -> void:
	caster = _caster
	target_grid = _target_grid

	var start_grid = _caster.get_component(GameData.ComponentKeys.POSITION).grid_pos


	# the grid pos the spell will move to when cast (since it moves on the same turn it is cast on)
	var _full_path: PackedVector2Array = MapFunction.get_line(start_grid, target_grid)
	# remove the first grid from the path, since it's the casters own grid
	_full_path.remove_at(0)

	full_path = _full_path

	# set first grid
	current_grid = Vector2i(full_path[0])

	position = MapFunction.to_world_pos(current_grid)
	GameData.main_node.add_child(self)



	if debug:
		print("spawned single target spell: ", uid)
		print("target grid: ", target_grid)
		print("full path: ", full_path)

	
	# emit spell casted signal

	SignalBus.spell_casted.emit({
		"caster": caster,
		"spell": self,
		"target_grid": target_grid
	})
		
func check_spell_path():
	pass

func check_grid(gird_pos: Vector2i) -> bool:

	var actor_at_pos = GameData.get_actor(gird_pos)
	if actor_at_pos:
		print("actor at next pos, spell hit")

		# call hit function
		# hit_actor(actor_at_pos)
		self.queue_free()
		return false

	
	if not MapFunction.is_tile_walkable(gird_pos):
		print("next tile not walkable, spell hits tile")

		# call collide function
		self.queue_free()
		return false

	if not MapFunction.is_in_bounds(gird_pos):
		print("next tile not in bounds, spell queue free")

		
		self.queue_free()
		return false

	
	# if next grid is avalible move to there
	position = MapFunction.to_world_pos(gird_pos)

	return true

func set_data() -> void:
	spell_type = GameData.SPELL_TYPE.OFFENSIVE
	spell_subtype = GameData.SPELL_SUBTYPE.TURRET

	if debug:
		print("turret spell data set")
