class_name LoadWorldMap
extends Node



static func load_biome_type_data() -> void:
	if FileAccess.file_exists(SavePaths.biome_type_world_map_data_save):
		var file = FileAccess.open_compressed(SavePaths.biome_type_world_map_data_save, FileAccess.READ)
		WorldMapData.biome_type = file.get_var()
		file.close()

static func load_world_map_savagery() -> void:
	if FileAccess.file_exists(SavePaths.world_map_savagery_save):
		var file = FileAccess.open_compressed(SavePaths.world_map_savagery_save, FileAccess.READ)
		WorldMapData.world_map_savagery = file.get_var()
		file.close()

static func load_world_map_civilization() -> void:
	if FileAccess.file_exists(SavePaths.world_map_civilization_save):
		var file = FileAccess.open_compressed(SavePaths.world_map_civilization_save, FileAccess.READ)
		WorldMapData.world_map_civilization = file.get_var()
		file.close()
	

static func load_world_maps(loading_screen: Control) -> void:
	print("[LoadWorldMap] loading all world maps")
	
	# Start threaded loads
	ResourceLoader.load_threaded_request(SavePaths.world_map_save)
	ResourceLoader.load_threaded_request(SavePaths.biome_map_save)
	ResourceLoader.load_threaded_request(SavePaths.world_monster_map_save)
	ResourceLoader.load_threaded_request(SavePaths.dungeon_map_save)

	print("[LoadWorldMap] loaded threads")
	
	# Wait for them to complete (can be done in separate function with progress)
	await _wait_for_loads(loading_screen)
	
	# Apply the loaded data
	WorldMapData.world_map2.map_data = ResourceLoader.load_threaded_get(SavePaths.world_map_save).map_data
	print("[LoadWorldMap] loaded world map")
	
	WorldMapData.biome_map.map_data = ResourceLoader.load_threaded_get(SavePaths.biome_map_save).map_data
	print("[LoadWorldMap] loaded biome map")
	
	WorldMapData.world_monster_map.map_data = ResourceLoader.load_threaded_get(SavePaths.world_monster_map_save).map_data
	print("[LoadWorldMap] loaded world monster map")
	
	WorldMapData.dungeons.dungeons = ResourceLoader.load_threaded_get(SavePaths.dungeon_map_save).dungeons
	print("[LoadWorldMap] loaded dungeons map")

static func _wait_for_loads(loading_screen: Control) -> void:
	var paths = [
		SavePaths.world_map_save,
		SavePaths.biome_map_save,
		SavePaths.world_monster_map_save,
		SavePaths.dungeon_map_save
	]

	var path_names = [
		"World Map",
		"Biome Map",
		"Monster Map",
		"Dungeon Map"
	]

	loading_screen._on_loading_label_changed("Loading Game...")

	while true:
		var all_loaded = true
		var total_progress = 0.0
		
		for i in range(paths.size()):
			var progress_array = []
			var status = ResourceLoader.load_threaded_get_status(paths[i], progress_array)
			
			# progress_array[0] contains the progress value (0.0 to 1.0)
			var individual_progress = progress_array[0] if progress_array.size() > 0 else 0.0
			total_progress += individual_progress
			
			# # Optional: Update label with current loading item
			# if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# 	loading_screen._on_loading_label_changed("Loading %s... %.0f%%" % [path_names[i], individual_progress * 100])
			
			if status != ResourceLoader.THREAD_LOAD_LOADED:
				all_loaded = false
			elif status == ResourceLoader.THREAD_LOAD_FAILED:
				push_error("Failed to load: " + paths[i])
				return
		
		# Calculate average progress across all files (0.0 to 1.0)
		var average_progress = total_progress / paths.size()
		loading_screen._loading_screen_progressed(average_progress)
		loading_screen._on_loading_label_changed("Loading Game... %.0f%%" % [average_progress * 100])
		
		if all_loaded:
			break
		
		await Engine.get_main_loop().process_frame
	
	# Ensure progress bar shows 100% when done
	loading_screen._loading_screen_progressed(1.0)
	loading_screen._on_loading_label_changed("Loading Complete!")



# BASE SAVES

# variables load
static func load_base_biome_type_data():
	if FileAccess.file_exists(DirectoryPaths.biome_type_world_map_base_data_save):
		var file = FileAccess.open_compressed(DirectoryPaths.biome_type_world_map_base_data_save, FileAccess.READ)
		WorldMapData.biome_type = file.get_var()
		file.close()

static func load_base_world_map_savagery():
	if FileAccess.file_exists(DirectoryPaths.world_map_savagery_base_save):
		var file = FileAccess.open_compressed(DirectoryPaths.world_map_savagery_base_save, FileAccess.READ)
		WorldMapData.world_map_savagery = file.get_var()
		file.close()

static func load_base_world_map_civilization():
	if FileAccess.file_exists(DirectoryPaths.world_map_civilization_base_save):
		var file = FileAccess.open_compressed(DirectoryPaths.world_map_civilization_base_save, FileAccess.READ)
		WorldMapData.world_map_civilization = file.get_var()
		file.close()


# custom loads
static func load_base_world_maps() -> void:
	WorldMapData.world_map2.load_base_world_map()
	WorldMapData.biome_map.load_base_biome_map()
	WorldMapData.world_monster_map.load_base_world_monster_map()
	WorldMapData.dungeons.load_base_dungeon_map()
