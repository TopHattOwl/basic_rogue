class_name HitPariclesComponent
extends SpellComponent

@export var hit_particles: PackedScene


func on_hit(_spell: SpellResource = null, _spell_instance: SpellNode = null, _caster: Node2D = null, _target_grid: Variant = null) -> void:

	var particles = hit_particles.instantiate()
	particles.global_position = MapFunction.to_world_pos(_target_grid)

	GameData.main_node.add_child(particles)

func spawn_hit_particles(_target_grid: Vector2i) -> void:

	var particles = hit_particles.instantiate()

	particles.global_position = MapFunction.to_world_pos(_target_grid)
	GameData.main_node.add_child(particles)
	
