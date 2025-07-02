class_name Particle
extends Node2D
# when making a particle node add a CPUParticles2D as child and add it to particle variable

@export var particle: CPUParticles2D

func _ready() -> void:
    particle.emitting = true