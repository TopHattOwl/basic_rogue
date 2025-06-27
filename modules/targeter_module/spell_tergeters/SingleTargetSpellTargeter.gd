class_name SingleTargetSpellTargeter
extends TargeterModule


var aoe: int = 0


## spell needs range
## targeter pos is set to mouse
## if aoe is not given -> 0 and the spell is single target
## textures are set to base of none are given
## Sets avalible tiles for the spell aiming targeter
func _init(avalible_tiles: Array[Vector2i], _aoe: int = 0, _targeter_texture: Texture2D = null, _path_texture: Texture2D = null) -> void:
	if GameData.spell_debug:
		print("Iniializing spell aiming targeter module")

	aoe = _aoe

	if !_targeter_texture:
		targeter_texture = load(DirectoryPaths.base_targeter_art)
	if !_path_texture:
		path_texture = load(DirectoryPaths.base_targeter_path_art)

	# Add in avalible tiles scene and it to TargererModule's variable
	var avalible_tiles_scene = load(DirectoryPaths.available_tile_scene)
	var _avalible_tiles_node = avalible_tiles_scene.instantiate()
	_avalible_tiles_node.set_avalible_tiles(avalible_tiles)
	avalible_tiles_node = _avalible_tiles_node

	GameData.main_node.add_child(avalible_tiles_node)

## activates the targeter
## adds targeter_sprite
func activate():
	if GameData.spell_debug:
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


func update_visuals() -> void:
	targeter_sprite.global_position = MapFunction.to_world_pos(SpellAimingSystem.current_target_grid)

	
	# for each grid in path line add a Spre2D to the scene and to path_sprites array
	for grid in path_line:
		var _path_sprite = Sprite2D.new()
		_path_sprite.texture = path_texture
		_path_sprite.z_index = 20
		_path_sprite.z_as_relative = false
		_path_sprite.global_position = MapFunction.to_world_pos(Vector2i(grid))
		_path_sprite.name = "SpellAimingTargeterPath"

		path_sprites.append(_path_sprite)

		GameData.main_node.add_child(_path_sprite)

