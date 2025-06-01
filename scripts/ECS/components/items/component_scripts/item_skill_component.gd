class_name ItemSkillComponent
extends Node


var skill: int = 0


func initialize(d: Dictionary) -> void:
    skill = d.get("skill", 0)