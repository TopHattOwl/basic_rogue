extends Node

var abilities = []


func initialize(d: Dictionary) -> void:
    abilities = d.get("abilities", [])