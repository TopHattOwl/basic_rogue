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
var path_sprite: Sprite2D


## the position of the targeter
var target_pos: Vector2i = Vector2i.ZERO

## max range the targeter can be moved to
## if set to 0 no range limit
var max_range: int = 0


## min and max grids get calculated from max_range if given
var min_grid: Vector2i = Vector2i.ZERO
var max_grid: Vector2i = Vector2i.ZERO


var avalible_tiles: Array


func set_available_tiles() -> void:
	if max_range == 0:
		return

	set_min_grid()
	set_max_grid()





## --- Min and Max grid calculators
## Only gets called if max_range is not 0 
func set_min_grid() -> Vector2i:
	var _min_grid := Vector2i.ZERO

	var player_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos




	MapFunction

	return _min_grid


func set_max_grid() -> Vector2i:
	var _max_grid := Vector2i.ZERO


	return _max_grid