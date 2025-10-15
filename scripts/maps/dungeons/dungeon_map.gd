class_name DungeonMap
extends Resource

@export var dungeons: Array[Dungeon]


func add_dungeon(dungeon: Dungeon) -> void:
	dungeons.append(dungeon)

func get_dungeon_by_id(id: int) -> Dungeon:	
	var i = dungeons.find_custom(func(dungeon: Dungeon) -> bool:
		return dungeon.id == id)
	
	if i == -1:
		return null
	return dungeons[i]

func enter_dungeon():
	pass

	
# BASE SAVES
func save_base_dungeon_map() -> void:
	ResourceSaver.save(self, DirectoryPaths.dungeon_map_base_save)


func load_base_dungeon_map() -> void:
	if ResourceLoader.exists(DirectoryPaths.dungeon_map_base_save):
		var loaded_data = ResourceLoader.load(
			DirectoryPaths.dungeon_map_base_save,
			"",
			ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
		)
		dungeons = loaded_data.dungeons