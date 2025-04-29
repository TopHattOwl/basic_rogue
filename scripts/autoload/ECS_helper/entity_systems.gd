extends Node

# gets all systems
var movement_system = preload(DirectoryPaths.movement_system).new()
var combat_system = preload(DirectoryPaths.combat_system).new()
var entity_spawner = preload(DirectoryPaths.entity_spawner).new()

func initialize_systems(main: Node2D):
	
	# sets each system's main node variable to the MainNode
	movement_system.main_node = main
	entity_spawner.main_node = main
