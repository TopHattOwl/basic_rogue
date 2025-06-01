class_name LogMessage
extends Node

# --- PLAYER ATTACK ---
static func make_player_attack_message(target: Node2D, damage: int, element: int, hit_action: int = 0) -> String:
	var target_name = ComponentRegistry.get_component(target, GameData.ComponentKeys.IDENTITY).actor_name 
	var text : = ""
	match hit_action:
		0: # hit
			var damage_color = get_damage_color(element)
			text = "You hit the [color={0}]{1}[/color] for [color={2}]{3}[/color] damage".format([
				target.text_color,
				target_name,
				damage_color,
				str(damage)
			])
		1: # miss
			text = "You missed the [color={0}]{1}[/color]".format([
				target.text_color,
				target_name
			])
		2: # target dodged
			text = "The [color={0}]{1}[/color] dodged your attack".format([
				target.text_color,
				target_name
			])

	return text

static func get_damage_color(element: int) -> String:
	match element:
		GameData.ELEMENT.PHYSICAL:
			return "#bbbab5"
		GameData.ELEMENT.FIRE:
			return "#a62121"
		GameData.ELEMENT.ICE:
			return "#56dcb4"
		GameData.ELEMENT.LIGHTNING:
			return "#dee310"
		GameData.ELEMENT.BLOOD:
			return "#591e18"
		GameData.ELEMENT.POISON:
			return "#2e610f"
		_:
			return "#bbbab5"


# --- MONSTER ATTACK ---

static func make_monster_attack_message(monster: Node2D, damage: int, hit_action: int) -> String:
	var monster_name = ComponentRegistry.get_component(monster, GameData.ComponentKeys.IDENTITY).actor_name
	var element = ComponentRegistry.get_component(monster, GameData.ComponentKeys.MONSTER_COMBAT).element
	var text: = ""

	match hit_action:
		0: # hit
			text = "The [color={0}]{1}[/color] hit you for [color={2}]{3}[/color] damage".format([
				monster.text_color,
				monster_name,
				get_damage_color(element),
				str(damage)
			])
		1: # miss
			text = "The [color={0}]{1}[/color] missed you".format([
				monster.text_color,
				monster_name
			])
		2: # player dodged
			text = "You dodged the [color={0}]{1}'s[/color] attack".format([
				monster.text_color,
				monster_name
			])

	return text