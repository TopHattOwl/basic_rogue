class_name SpellParticle
extends Node2D


@export var particle: CPUParticles2D


func _ready() -> void:
    particle.emitting = true