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


	# --- items testing ---
	var inv_comp: InventoryComponent = GameData.player.InventoryComp

	var test_weapon = ItemFactory.create_item(ItemDefinitions.ITEMS.IRON_LONGSWORD)
	inv_comp.add_item(test_weapon)

	var test_powder = ItemFactory.create_item(ItemDefinitions.ITEMS.TEST_POWDER)
	inv_comp.add_item(test_powder)

	var test_resource = ItemFactory.create_item(ItemDefinitions.ITEMS.IRON_LUMP, 24)
	inv_comp.add_item(test_resource)

	var test_helmet = ItemFactory.create_item(ItemDefinitions.ITEMS.STEEL_HELMET)
	var test_cloak = ItemFactory.create_item(ItemDefinitions.ITEMS.CLOAK)
	var test_gauntlets = ItemFactory.create_item(ItemDefinitions.ITEMS.STEEL_GAUNTLETS)
	inv_comp.add_item(test_helmet)
	inv_comp.add_item(test_cloak)
	inv_comp.add_item(test_gauntlets)


	# --- items testing end ---


	# spell test

	var test_spell = SpellFactory.create_spell(DirectoryPaths.spell_resources.test_spell, DirectoryPaths.spell_scenes.test_spell)
	var test_turret_spell = SpellFactory.create_spell(DirectoryPaths.spell_resources.test_turret_spell, DirectoryPaths.spell_scenes.test_turret_spell)
	GameData.player.SpellsComp.learn_spell(test_spell)
	GameData.player.SpellsComp.learn_spell(test_turret_spell)


	GameData.player.HotbarComp.add_to_hotbar("spell", test_spell.spell_data.uid, "hotbar_1")
	GameData.player.HotbarComp.add_to_hotbar("spell", test_turret_spell.spell_data.uid, "hotbar_2")


	# GameData.player.SkillsComp.unlock_passive(GameData.SKILLS.SWORD, SkillDefinitions.PASSIVE_IDS.PLACEHOLDER_SWORD, true)
	# GameData.player.SkillsComp.unlock_passive(GameData.SKILLS.MACE, SkillDefinitions.PASSIVE_IDS.PLACEHOLDER_MACE, true)
	# GameData.player.SkillsComp.unlock_passive(GameData.SKILLS.SWORD, SkillDefinitions.PASSIVE_IDS.CHILD_OF_PLACEHOLDER, true)

func _process(_delta):
# input handler, gets input passed to it and depending on what input is pressed it calls different functions
	if GameData.player.PlayerComp.is_players_turn:

		input_manager.handle_input()


func get_player_comp(comp_key: int) -> Node:
	return ComponentRegistry.get_player_comp(comp_key)

func get_player_pos() -> Vector2i:
	return ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos
