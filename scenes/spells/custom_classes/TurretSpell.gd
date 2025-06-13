class_name TurretSpell
extends SpellNode

@export var animated_sprite: AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play() 


func set_data() -> void:
	spell_type = GameData.SPELL_TYPE.OFFENSIVE
	spell_subtype = GameData.SPELL_SUBTYPE.TURRET

	if debug:
		print("turret spell data set")
