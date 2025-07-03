extends Node

const MELEE_SKILL_EXP_MOD = 0.3
const WEAPON_SKILL_EXP_MOD = 0.45

func _ready() -> void:
	SignalBus.actor_hit_final.connect(_on_actor_hit_final)


func _on_actor_hit_final(hit_data: Dictionary) -> void:


	if hit_data.target == GameData.player:
		calc_player_ht_exp(hit_data)
	elif hit_data.attacker == GameData.player:
		calc_player_attack_exp(hit_data)

func calc_player_attack_exp(hit_data: Dictionary) -> void:
	if hit_data.combat_type == GameData.COMBAT_TYPE.MELEE:
		if hit_data.hit_action == GameData.HIT_ACTIONS.HIT:
			var melee_skill_exp_gain = hit_data.damage * MELEE_SKILL_EXP_MOD
			var weapon_skill_exp_gain = hit_data.damage * WEAPON_SKILL_EXP_MOD
			var player_skill_comp = GameData.player.SkillsComp


			var weapon_skill_type = get_weapon_type()
			if weapon_skill_type == -1:
				return ## if no weapon -> no exp

			player_skill_comp.add_exp(GameData.SKILLS.MELEE, melee_skill_exp_gain)
			player_skill_comp.add_exp(weapon_skill_type, weapon_skill_exp_gain)

	elif hit_data.combat_type == GameData.COMBAT_TYPE.SPELL:

		print("player attacked spell -> give element skill xp")

func calc_player_ht_exp(hit_data: Dictionary) -> void:
	if hit_data.hit_action == GameData.HIT_ACTIONS.BLOCKED:
		print("player blocked hit -> give block skill xp, not yet implemented")


## returns the correct SKILL type (from GameData.SKILLS) depending on the weapon type [br]
## returns -1 if no weapon
func get_weapon_type() -> int:
	var melee_weapon = GameData.player.EquipmentComp.equipment[GameData.EQUIPMENT_SLOTS.MAIN_HAND]
	if not melee_weapon:
		return -1
	match melee_weapon.get_component(MeleeWeaponComponent).weapon_type:
		GameData.WEAPON_TYPES.SWORD:
			return GameData.SKILLS.SWORD
		GameData.WEAPON_TYPES.AXE:
			return GameData.SKILLS.AXE
		GameData.WEAPON_TYPES.SPEAR:
			return GameData.SKILLS.SPEAR
		GameData.WEAPON_TYPES.MACE:
			return GameData.SKILLS.MACE
		GameData.WEAPON_TYPES.POLEAXE:
			return GameData.SKILLS.POLEAXE
		_:
			return -1