class_name TargeterModule
extends Node2D
## Base targeter module. [br]
## Handles: [br]
	## The visual representation of the targeter's position [br]
	## Also handles avalible tiles for the targeter


## Targeter textures will be set when a TargeterModule is initialized if textures aregiven [br]
## Otherwise it's set to the base textures
@export var targeter_texture: Texture2D
@export var path_texture: Texture2D


## When TargeterModule is activated sprites will be made
var targeter_sprite: Sprite2D
var path_sprites: Array[Sprite2D] = []


## the position of the targeter
var target_pos: Vector2i = Vector2i.ZERO
var path_line: Array[Vector2i] = []


# avalible tiles for the targeter
var avalible_tiles_node: TileMapLayer

## NOT USED
## range limit is set in spell aiming system
## max range the targeter can be moved to
## if set to 0 no range limit
# var max_range: int = 0

## removes the prevous path sprites, resets the path line and adds the new one
func add_path_line(_path_line: Array[Vector2i]) -> void:

	for sprite in path_sprites:
		sprite.queue_free()
	path_sprites.clear()
	path_line.clear()

	path_line = _path_line


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if !path_sprites:
			return
		for sprite in path_sprites:
			sprite.queue_free()

		path_sprites.clear()

		avalible_tiles_node.queue_free()
