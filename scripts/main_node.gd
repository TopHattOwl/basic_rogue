extends Node2D
# --- INPUT ---
const INPUT_DIRECTIONS = GameData.INPUT_DIRECTIONS
@export var input_manager: Node = null
	
func _ready():

	# passing main node to game data
	GameData.main_node = self
	SignalBus.game_state_changed.emit(GameState.GAME_STATES.PLAYING)

	EntitySpawner.spawn_player()

	# --- TESTING ---

	# test stances
	GameData.player.StanceComp.add_stance(load("res://resources/combat_stuff/stances/test.tres"))
	GameData.player.StanceComp.add_stance(load("res://resources/combat_stuff/stances/test2.tres"))
	# GameData.player.StanceComp.enter_stance(GameData.player.StanceComp.known_stances[0])

	# test weapon
	var test_weapon: ItemResource = ItemFactory.create_item("res://resources/items/item_instances/weapons/test_weapon.tres")

	var resource1: ItemResource = ItemFactory.create_item("res://resources/items/item_instances/resources/test_resource.tres", 11)
	var resource2: ItemResource = ItemFactory.create_item("res://resources/items/item_instances/resources/test_resource.tres", 3)
	var resource3: ItemResource = ItemFactory.create_item("res://resources/items/item_instances/resources/test_resource.tres", 5)

	GameData.player.InventoryComp.add_item(resource1)
	GameData.player.InventoryComp.add_item(resource2)
	GameData.player.InventoryComp.add_item(resource3)
	GameData.player.InventoryComp.add_item(test_weapon)


	# powder test
	var powder: ItemResource = ItemFactory.create_item("res://resources/items/item_instances/powders/test_powder.tres")
	var powder2: ItemResource = ItemFactory.create_item("res://resources/items/item_instances/powders/test_powder2.tres")

	GameData.player.InventoryComp.add_item(powder)
	GameData.player.InventoryComp.add_item(powder2)

	# GameData.player.get_component(GameData.ComponentKeys.MELEE_COMBAT).reset_to_unarmed()


	# spell test

	var test_spell = SpellFactory.create_spell(DirectoryPaths.spell_resources.test_spell, DirectoryPaths.spell_scenes.test_spell)
	var test_turret_spell = SpellFactory.create_spell(DirectoryPaths.spell_resources.test_turret_spell, DirectoryPaths.spell_scenes.test_turret_spell)
	GameData.player.SpellsComp.learn_spell(test_spell)
	GameData.player.SpellsComp.learn_spell(test_turret_spell)


	GameData.player.HotbarComp.add_to_hotbar("spell", test_spell.spell_data.uid, "hotbar_1")
	GameData.player.HotbarComp.add_to_hotbar("spell", test_turret_spell.spell_data.uid, "hotbar_2")


	GameData.player.SkillsComp.unlock_passive(GameData.SKILLS.SWORD, SkillDefinitions.PASSIVE_IDS.PLACEHOLDER_SWORD, true)
	GameData.player.SkillsComp.unlock_passive(GameData.SKILLS.MACE, SkillDefinitions.PASSIVE_IDS.PLACEHOLDER_MACE, true)
	GameData.player.SkillsComp.unlock_passive(GameData.SKILLS.SWORD, SkillDefinitions.PASSIVE_IDS.CHILD_OF_PLACEHOLDER, true)

func _process(_delta):
# input handler, gets input passed to it and depending on what input is pressed it calls different functions
	if GameData.player.PlayerComp.is_players_turn:

		input_manager.handle_input()


func get_player_comp(comp_key: int) -> Node:
	return ComponentRegistry.get_player_comp(comp_key)

func get_player_pos() -> Vector2i:
	return ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos
