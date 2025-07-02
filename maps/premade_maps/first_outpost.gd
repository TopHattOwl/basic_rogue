extends Node2D



func _ready():

	EntitySpawner.spawn_monster(Vector2i(10, 10), GameData.MONSTERS_ALL.IRON_WORM)
	EntitySpawner.spawn_monster(Vector2i(12, 11), GameData.MONSTERS_ALL.IRON_WORM)
	EntitySpawner.spawn_monster(Vector2i(13, 10), GameData.MONSTERS_ALL.IRON_WORM)
	# EntitySpawner.spawn_monster(Vector2i(15, 14), GameData.MONSTERS_ALL.BIG_B)

	# spawn wizard here and and load it's data from json
	pass
