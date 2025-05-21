extends TileMapLayer

@export var vision_range := 6
var explored_map := []
var player_pos: Vector2i

@export var unexplored_tile_data := {
	"source_id": 0,
	"atlas_coords": Vector2i(0, 0),
}

@export var explored_tile_data := {
	"source_id": 1,
	"atlas_coords": Vector2i(0, 0),
}

func _ready() -> void:
	explored_map.resize(GameData.MAP_SIZE.y)
	for y in GameData.MAP_SIZE.y:
		explored_map[y] = []
		explored_map[y].resize(GameData.MAP_SIZE.x)
		explored_map[y].fill(false)
	

func _process(_delta: float) -> void:
	update_player_position()
	_update_fov()

func update_player_position():
	var pos_comp = ComponentRegistry.get_component(GameData.player, GameData.ComponentKeys.POSITION)
	if pos_comp:
		player_pos = pos_comp.grid_pos

func _update_fov():
	var cells_to_update := []
	
	for y in GameData.MAP_SIZE.y:
		for x in GameData.MAP_SIZE.x:
			var grid_pos = Vector2i(x, y)
			var in_vision = is_in_vision(grid_pos)
			var was_explored = explored_map[y][x]
			
			if in_vision:
				explored_map[y][x] = true
				clear_cell_if_needed(grid_pos)
			elif _needs_redraw(grid_pos):
				cells_to_update.append(grid_pos)
	
	update_cells_batch(cells_to_update)

func clear_cell_if_needed(grid_pos: Vector2i):
	if get_cell_source_id(grid_pos) != -1:
		set_cell(grid_pos,)

func update_cells_batch(cells: Array):
	for grid_pos in cells:
		var tile_data = explored_tile_data if explored_map[grid_pos.y][grid_pos.x] else unexplored_tile_data
		set_cell(grid_pos, tile_data.source_id, tile_data.atlas_coords)
	update_internals()

func is_in_vision(grid_pos: Vector2i) -> bool:
	return grid_pos.distance_to(player_pos) <= vision_range

func _needs_redraw(grid_pos: Vector2i) -> bool:
	if grid_pos.x < 0 || grid_pos.y < 0 || grid_pos.x >= GameData.MAP_SIZE.x || grid_pos.y >= GameData.MAP_SIZE.y:
		return false
	
	var is_explored = explored_map[grid_pos.y][grid_pos.x]
	var cell_data = get_cell_tile_data(grid_pos)
	
	if not is_instance_valid(cell_data):
		return true  # Missing tile that should exist
	
	var expected_data = explored_tile_data if is_explored else unexplored_tile_data

	if cell_data == null:
		return true
	if cell_data.source_id == expected_data.source_id && cell_data.atlas_coords == expected_data.atlas_coords:
		return false
	else:
		return true
	return (cell_data.source_id != expected_data.source_id ||
			cell_data.atlas_coords != expected_data.atlas_coords)
