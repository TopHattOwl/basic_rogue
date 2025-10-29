extends HBoxContainer

@onready var hp_progress: TextureProgressBar = $HpAndStamina/HPProgress
@onready var hp_value: Label = $HpAndStamina/HPValue

@onready var stamina_progress: TextureProgressBar = $HpAndStamina/StaminaProgress
@onready var stamina_value: Label = $HpAndStamina/StaminaValue

@onready var weapon_capacity_progress: TextureProgressBar = $Capacity/WeaponCapacityprogress
@onready var weapon_capacity_value: Label = $Capacity/WeaponCapacityvalue

@onready var armor_capacity_progress: TextureProgressBar = $Capacity/ArmorCapacityProgress
@onready var armor_capacity_value: Label = $Capacity/ArmorCapacityValue

func _ready() -> void:
	var health_comp: HealthComponent = GameData.player.HealthComp
	set_player_hp(health_comp.hp, health_comp.max_hp)

	SignalBus.player_hp_changed.connect(set_player_hp)


func set_player_hp(hp: int, max_hp: int) -> void:
	hp_value.text = str(hp) + "/" + str(max_hp)
	hp_progress.value = float(hp) / float(max_hp)

func set_player_stamina() -> void:
	pass

func set_player_weapon_capacity() -> void:
	pass

func set_player_armor_capacity() -> void:
	pass
