class_name SpellsComponent
extends Node

var spells = []

func initialize(d: Dictionary) -> void:
    spells = d.get("spells", [])