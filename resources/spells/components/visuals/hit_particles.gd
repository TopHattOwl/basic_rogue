class_name HitPariclesComponent
extends SpellComponent

@export var hit_particles: PackedScene


func on_hit(_spell: SpellResource, _spell_instance: SpellNode, _caster: Node2D, _target_grid: Variant = null) -> void:
	print("making hit particles")

	var particles = hit_particles.instantiate()
	particles.global_position = MapFunction.to_world_pos(_target_grid)

	GameData.main_node.add_child(particles)
	
