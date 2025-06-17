class_name SpellAimingTargeter
extends TargeterModule


var aoe: int = 0


## spell needs range
## targeter pos is set to mouse
## if aoe is not given -> 0 and the spell is single target
## textures are set to base of none are given
## Sets avalible tiles for the spell aiming targeter
func _init(_spell_range, _aoe: int = 0, _targeter_texture: Texture2D = null, _path_texture: Texture2D = null) -> void:

	print("Iniializing spell aiming targeter module")
	max_range = _spell_range
	aoe = _aoe
	target_pos = MapFunction.zoomed_in_mouse_pos

	if !_targeter_texture:
		targeter_texture = load(DirectoryPaths.base_targeter_art)
	if !_path_texture:
		path_texture = load(DirectoryPaths.base_targeter_path_art)

	set_available_tiles()

## activates the targeter
## adds targeter_sprite
func activate():
	print("Spell aiming targeter activated")

	# adding targeter sprite and setting position
	var _targeter_sprite = Sprite2D.new()
	_targeter_sprite.texture = targeter_texture
	_targeter_sprite.z_index = 20
	_targeter_sprite.z_as_relative = false
	_targeter_sprite.global_position = MapFunction.to_world_pos(MapFunction.zoomed_in_mouse_pos)
	_targeter_sprite.name = "SpellAimingTargeter"

	targeter_sprite = _targeter_sprite

	add_child(targeter_sprite)

	# set spell aiming system's targeter to self
	SpellAimingSystem.targeter = self

	GameData.player.add_child(self)



func _update_position() -> void:
	pass


# func _process(_delta: float) -> void:
# 	pass

	# if !needs_update():
	# 	return

	# target_pos = MapFunction.zoomed_in_mouse_pos
	# SpellAimingSystem.current_target_grid = target_pos
	# targeter_sprite.global_position = MapFunction.to_world_pos(target_pos)
	


func _ready() -> void:

	print("Spell aiming targeter ready")


func needs_update() -> bool:
	if target_pos == MapFunction.zoomed_in_mouse_pos:
		return false
	return true
