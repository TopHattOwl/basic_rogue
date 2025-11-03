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

	var test_poleaxe = ItemFactory.create_item(ItemDefinitions.ITEMS.IRON_POLEAXE)
	inv_comp.add_item(test_poleaxe)

	var test_steel_sword = ItemFactory.create_item(ItemDefinitions.ITEMS.STEEL_LONGSWORD)
	inv_comp.add_item(test_steel_sword)

	var test_steel_dagger = ItemFactory.create_item(ItemDefinitions.ITEMS.STEEL_DAGGER)
	inv_comp.add_item(test_steel_dagger)

	var test_shield = ItemFactory.create_item(ItemDefinitions.ITEMS.ROUND_SHIELD)
	inv_comp.add_item(test_shield)

	var test_powder = ItemFactory.create_item(ItemDefinitions.ITEMS.TEST_POWDER)
	inv_comp.add_item(test_powder)

	var test_resource = ItemFactory.create_item(ItemDefinitions.ITEMS.IRON_LUMP, 24)
	inv_comp.add_item(test_resource)

	var test_helmet = ItemFactory.create_item(ItemDefinitions.ITEMS.STEEL_HELMET)
	var test_cloak = ItemFactory.create_item(ItemDefinitions.ITEMS.CLOAK)
	var test_gauntlets = ItemFactory.create_item(ItemDefinitions.ITEMS.STEEL_GAUNTLETS)
	var test_belt = ItemFactory.create_item(ItemDefinitions.ITEMS.LEATHER_BELT)
	inv_comp.add_item(test_helmet)
	inv_comp.add_item(test_cloak)
	inv_comp.add_item(test_gauntlets)
	inv_comp.add_item(test_belt)


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

	# SkillFactory.print_skill_tree(GameData.SKILLS.SWORD)

	# --- haste modifier test ---
	# var player_stat_mod_comp: ModifiersComponent = GameData.player.ModifiersComp

	# var _hase_buff: StatModifier = ModifierFactory.make_singe_modifier({
	# 	"target_component": GameData.ComponentKeys.ENERGY,
	# 	"target_stat": "base_speed",
	# 	"operation": GameData.MODIFIER_OPERATION.MULTIPLY,
	# 	"value": 1.5 # 50% faster actions globally
	# })[0]

	# player_stat_mod_comp.add_energy_modifier(_hase_buff)


	# # pick up window test
	# var item1 = ItemFactory.create_item(ItemDefinitions.ITEMS.STEEL_HELMET)
	# var item2 = ItemFactory.create_item(ItemDefinitions.ITEMS.IRON_LUMP)
	# var item3 = ItemFactory.create_item(ItemDefinitions.ITEMS.CLOAK)
	# var pick_up_window: PickUpWindowControlNode = load(DirectoryPaths.pick_up_window_scene).instantiate()
	# pick_up_window.setup([item1, item2, item3])
	# UiFunc.player_ui.add_child(pick_up_window)
	

func _process(_delta):
# input handler, gets input passed to it and depending on what input is pressed it calls different functions
	if GameData.player.PlayerComp.is_players_turn:

		input_manager.handle_input()
	else:
		# process 10 turns in a frame
		for i in range(10):
			GameData.energy_turn_manager.process_next_action()

			if GameData.player.PlayerComp.is_players_turn:
				break


func get_player_comp(comp_key: int) -> Node:
	return ComponentRegistry.get_player_comp(comp_key)

func get_player_pos() -> Vector2i:
	return ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos
