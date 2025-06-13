class_name SingleTargetSpell
extends SpellNode

## The distance the spell has moved 
@export var distance_traveled: int

@export var animated_sprite: AnimatedSprite2D


var full_path: PackedVector2Array

func _ready() -> void:
	print("spell ready")
	distance_traveled = 0

	animated_sprite.play()

	SignalBus.player_acted.connect(_on_player_acted)


func _on_player_acted() -> void:
	print("spell moved")


func cast_spell(_caster: Node2D, _target_grid: Vector2i) -> void:
	caster = _caster
	target_grid = _target_grid
	

	# grid direction
	var start_grid = _caster.get_component(GameData.ComponentKeys.POSITION).grid_pos
	var grid_dir = clamp(target_grid - start_grid, Vector2i(-1, -1), Vector2i(1, 1))


	# real direction
	var start_pos = MapFunction.to_world_pos(start_grid)
	var target_pos = MapFunction.to_world_pos(target_grid)
	var dir = (target_pos - start_pos).normalized()
	dir = dir.normalized()

	# set rotation
	rotation = dir.angle() + deg_to_rad(spell_data.get_component(TravelVisualComponent).rotation_adjust)

	# the grid pos the spell will move to when cast (since it moves on the same turn it is cast on)
	var _full_path: PackedVector2Array = MapFunction.astar_get_path(start_grid, target_grid)
	# remove the first grid from the path, since it's the casters own grid
	_full_path.remove_at(0)

	full_path = _full_path

	# set first grid
	current_grid = Vector2i(full_path[0])	

	position = start_pos
	GameData.main_node.add_child(self)

	check_spell_path()

	if debug:
		print("spawned single target spell: ", spell_data.uid)
		print("full path: ", full_path)
	

func check_spell_path() -> void:

	var speed = spell_data.get_component(SingleTargetComponent).speed

	# check each grid in path
	for i in range(speed):
		check_current_grid()

		distance_traveled += 1

		current_grid = Vector2i(full_path[distance_traveled])

	pass

func check_next_grid() -> void:
	pass

func check_current_grid() -> void:

	# check if spell is at end of path
	if distance_traveled >= full_path.size():
		print("spell at end of path, queue free")
		self.queue_free()
		return


	var actor_at_pos = GameData.get_actor(current_grid)
	if actor_at_pos:
		print("actor at pos, spell hit")
		self.queue_free()
		return
	
	if not MapFunction.is_tile_walkable(current_grid):
		print("tile not walkable, spell hit tile")
		self.queue_free()
		return
	
	if not MapFunction.is_in_bounds(current_grid):
		print("tile not in bounds, spell queue free")
		self.queue_free()
		return

	# if not hit anything, move to next grid
	position = MapFunction.to_world_pos(current_grid)


func set_data() -> void:
	spell_type = GameData.SPELL_TYPE.OFFENSIVE
	spell_subtype = GameData.SPELL_SUBTYPE.SINGLE_TARGET

	if debug:
		print("single target spell data set")
