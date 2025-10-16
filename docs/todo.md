# BUGS:
	# level up particle sometimes doesn't exit the tree

# REMOVE:
	# Iron_worm and Mask monster scenes and scripts, now its done in code
	# Monster node class its now MonsterBase and it's children

	# monster tier not used anymore, remove form everywhere (WorldMonsterTiles, WorldMonsterMap, etc.)

# REWORK:
	# VERY IMPORTANT:
		# Move biome generation to Biome class, each biome should extend Biome class
	# make buffs, weapons, all resources basically in code:
		# right now if I change order of enums it could fuck the game up
		# things interacting with modifiers comp could be affected for sure, maybe others
	

# finish:
	# VERY IMPORTANT:
		# save and load for skills temporarily removed bc of rework
		# world_map node's field tilemap layer has generig tileset not the already made one in resources/tiles/world_map_tiles/field_tiles.tres
		# monster melee component not taking modifiers into account in monster_combat_component.gd

	# in entity_systems item spawner is decrepit

	# ui_func.gd finnish message log, when using spells write spell etc.

	# finish dungeon class and dungeon level class for everything, not just field
	# biome class for everything, not just field
	# every type of buff and stat modifier and relevant stuff, connected to it, right now mostly only melee combat modifiers is done:
		# ui elements for buffs: buff_hover_tooltip, buff_icon
		# modifier system
		# modifier component
	# from monster nodes remove armor from monster stats and remove element weight
	# DEFENSIVE SPELLS SUBTYPES in GameData enum 
	


# IDEAS:
	# IMPORTANT:
		# LAST TARGET autoload:
			# autoload for handling player's combat targets, when player attacks an actor set last target to it
			# when player aims offensive spell/ability set the target to the last target
	# craftable component:
		# known: bool, dows player know this recepie
		# crating_cost: Dictionary of resources and amounts
		# crafting_station: int from enum CRAFTING_STATIONS (alchemy for powder, potions | cooking station for food)
		# craftable_by_player: bool if player can craft it themself or have to bring it to a special crafter (like monster weapons need to be made with a specaial crafter)

	# player can do things like clear a dungeon, fulfill contracts, etc 
	# stances could alter attack type: mordhau grip on sword changes to bash, dagger could change to pirece from slash if stabbing stance
	# messages:
		# when player does something (like clear a dungeon, fulfill a contract etc) dont incearse
	# reputation for cities and hunters and regions:
		# regions:
			# Regions have reputation, the regions bigest city is the region leader, each region has several citioes, villages etc
			# doing stuff in a region's city, castle etc. gives reputation to the settlement and a part of it to the other settlements of the region
	# foraging map (like terrain map, 2d array) for placing foraging objects for player to forage for potions, food and stuff
		# foraging vision -> based on perception and knowlege of plants (notice plants you know better)
		# foraging mode -> regular vision decreeses but foraging vision increases
		# add forage generation in Biome classes 

	# IMPORTANT: FOV how to
		# add TileMapLayer node to player node
		# in it's process function get player pos
		# variables: in vision tiles, expored_map (2d array, value is 1 if expored, 0 if not explored)
		# according to terrain_map transparency and player's vision range, map out what player sees, update explored map and in vision tiles
		# tilemap layer setcell:
			# none on tiles player actively sees
			# explored but not in vision tile: 50% transparency background map
			# not explored, not in vision tile: background tile full transparency

	# finish biome integration to class objects

# TODO:
	# VERY IMPORTANT:
		# Make sure dirung bioe generaion that the spawn pos (GameData.WORLD_SPAWN_POS) is clear of non walkable tiles
		# finish spell aiming system
		# make player unable to use powders that are already applied
		# make world map much larger, to the east, the longer you go east the less civilizations (settlements) there are -> stronger monsters
			# this way there can be more regions and more settlements, more dungeons and more contracts
		# scripts/systems/world_manager/  make the autoloads in this folder
		# 

	# IMPORTANT:
		# Fix ouse grid pos, right now bc of the CTR monitor effect, the mouse grid pos is off at the screne edges
		# TODO in SpellTargeter 
		# TODO in turn manager and PlayerComponent to finish action queueing
		# TODO in inventory_item.gd
		# player data load and save rework, handle it in player's own script
			# also make a save and load function for each component so that saveing and loading can be just iterating tru components and calling save and load functions
		# rework armor: armor stat (integer) should translate to % damage reduction (max is 80%)
		# remove item component from ECS/components/items/ it's stored in resources now since items are resources
		# make a modifiers component for the monsters as well
	# stance_bar.gd: check for weapon and armor type requirement -> only show stances that can be activated
	# add camera2d to targeter, make it active when looking
	# generate seed in WorldMap object using the world seed in GameData
	# Stamina and State componenet not finished
	# player_ui.gd make look ui array cycleable when looking at tile with more stuff
	# in world_map_data.gd add world_map_identity array, figure out what to put there, name, quests, notes, etc also add it to map generation
	# make thiner road tile for smaller roads
	# implement repost system for melee combat
	# GameTime add weeks and day names for each day in a week
	# Signal day_passed has no uses yet -> maybe for quests, messages, etc
	# pick up item
	
	# save_player.gd need to save player's previous input mode (band-aid fix) make a better version somehow