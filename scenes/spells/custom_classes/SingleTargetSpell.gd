class_name SingleTargetSpell
extends SpellNode
## single target spell moves in a line and hits the first obstacle
## fast spells, low damage, single target, low capacity cost

## The distance the spell has moved 
var distance_traveled: int

@export var animated_sprite: AnimatedSprite2D


var full_path: PackedVector2Array

var dam: int

func _ready() -> void:
	if debug:
		print(" --- SingleTargetSpell ready ---")
		print("Data set for spell: ", uid)
	SignalBus.projectile_spawned.emit({
		"spell": self
	})
	distance_traveled = 0

	animated_sprite.play()

func _process(_delta: float) -> void:
	check_grid(current_grid)

func process_turn() -> void:
	if debug:
		print("spell moving: ", uid)
	check_spell_path()


## SingleTargetSpell casting. [br]
## Sets the full path for the single target spell. [br]
## Spawns the spell at the first position. [br]
## Rotates the spell to face the target position. [br]
## Sets damage of the spell (this will be used when hitting an actor) [br]
## Emits spell casted signal
func cast_spell(_caster: Node2D, _target_grid: Vector2i) -> void:
	caster = _caster
	target_grid = _target_grid
	

	# grid
	var start_grid = _caster.get_component(GameData.ComponentKeys.POSITION).grid_pos

	# real direction
	var start_pos = MapFunction.to_world_pos(start_grid)
	var target_pos = MapFunction.to_world_pos(target_grid)
	var dir = (target_pos - start_pos).normalized()
	dir = dir.normalized()

	# set rotation
	rotation = dir.angle() + deg_to_rad(spell_data.get_component(TravelVisualComponent).rotation_adjust)

	# the grid pos the spell will move to when cast (since it moves on the same turn it is cast on)
	var _full_path: PackedVector2Array = MapFunction.get_line(start_grid, target_grid)
	# remove the first grid from the path, since it's the casters own grid
	_full_path.remove_at(0)

	full_path = _full_path

	# set first grid
	current_grid = Vector2i(full_path[0])

	dam = spell_data.get_component(SingleTargetComponent).calc_damage(self)


	position = MapFunction.to_world_pos(current_grid)
	GameData.main_node.add_child(self)

	if debug:
		print("spawned single target spell: ", uid)
		print("target grid: ", target_grid)
		print("full path: ", full_path)
		print("Spell type (enum value/name of type) {0}/{1} | sub type: {2}/{3}".format([
			spell_type,
			GameData.SPELL_TYPE_NAMES.get(spell_type),
			spell_subtype,
			GameData.SPELL_SUBTYPE_NAMES.get(spell_subtype)
		]))


	
	# emit spell casted signal
	# NOT USED
	# SignalBus.spell_casted.emit({
	# 	"caster": caster,
	# 	"spell": self,
	# 	"target_grid": target_grid
	# })

	
	
## checks spell path and moves the spell
## moves one tile at a time but in one turn moves multiple tiles (equal to speed)
func check_spell_path() -> void:

	# speed -> how many grids the spell moves per turn
	var speed = spell_data.get_component(SingleTargetComponent).speed

	# check if current grid hits something
	if !check_grid(current_grid):
		return

	# check each next grid in path
	for i in range(speed):

		# if checking the next grid hits something break
		if !check_next_grid():
			break
		

		distance_traveled += 1

		current_grid = Vector2i(full_path[distance_traveled])

func check_next_grid() -> bool:

	if distance_traveled + 1 >= full_path.size():
		if debug:
			print("spell at end of path, queue free: ", uid)
		self.queue_free()
		return false

	var next_grid = Vector2i(full_path[distance_traveled + 1])

	return check_grid(Vector2i(next_grid))

func check_grid(gird_pos: Vector2i) -> bool:

	var actor_at_pos = GameData.get_actor(gird_pos)
	if actor_at_pos:

		if debug:
			print("actor at pos, spell hit", uid)

		# call hit function
		hit_actor(actor_at_pos)
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
	spell_subtype = GameData.SPELL_SUBTYPE.SINGLE_TARGET


	if debug:
		print("single target spell data set")


func hit_actor(actor: Node2D) -> void:
	var dir = clamp(actor.get_component(GameData.ComponentKeys.POSITION).grid_pos - caster.get_component(GameData.ComponentKeys.POSITION).grid_pos, Vector2i(-1, -1), Vector2i(1, 1))

	var signal_hit_data = {
		"target": actor,
		"attacker": caster,
		"damage": dam,
		"direction": dir,
		"element": spell_data.element,
		"hit_action": GameData.HIT_ACTIONS.HIT,
		"combat_type": GameData.COMBAT_TYPE.SPELL
	}

	# do on hit animations

	# particles
	spell_data.get_component(HitPariclesComponent).spawn_hit_particles(actor.get_component(GameData.ComponentKeys.POSITION).grid_pos)

	SignalBus.actor_hit.emit(signal_hit_data)
	pass
