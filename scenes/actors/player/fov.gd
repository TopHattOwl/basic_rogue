extends Node2D

@export var fov_radius: int = 8
@export var visibility_tilemap_layer: TileMapLayer

var _tile_cache: Dictionary

# func _ready():
#     _build_tile_cache()
#     wall_layer.changed.connect(calculate_fov)

# func _build_tile_cache():
#     # Preprocess tile properties for quick lookup
#     for cell in wall_layer.get_used_cells():
#         var source_id = wall_layer.get_cell_source_id(cell)
#         var tile_data = wall_layer.get_cell_tile_data(cell)
#         _tile_cache[cell] = {
#             "blocking": tile_data.get_custom_data("blocking") if tile_data else false,
#             "source_id": source_id
#         }

# func calculate_fov(center: Vector2i):
#     visibility_tilemap_layer.clear()
#     var map_size = wall_layer.get_used_rect()
	
#     for dx in range(-fov_radius, fov_radius + 1):
#         for dy in range(-fov_radius, fov_radius + 1):
#             var target_cell = center + Vector2i(dx, dy)
#             if _is_in_fov(center, target_cell):
#                 visibility_tilemap_layer.set_cell(target_cell, 0, Vector2i.ZERO, 0)

# func _is_in_fov(origin: Vector2i, target: Vector2i) -> bool:
#     if not wall_layer.is_existing_cell(target): 
#         return false
	
#     var space_state = get_world_2d().direct_space_state
#     var origin_pos = wall_layer.map_to_local(origin)
#     var target_pos = wall_layer.map_to_local(target)
	
#     var params = PhysicsRayQueryParameters2D.new()
#     params.from = origin_pos
#     params.to = target_pos
#     params.collision_mask = 1
	
#     var result = space_state.intersect_ray(params)
#     return result.is_empty() || result.position.distance_to(target_pos) < wall_layer.tile_set.tile_size.x/2

# func _on_tile_changed(cell: Vector2i):
#     # Update cache when tiles change
#     var tile_data = wall_layer.get_cell_tile_data(cell)
#     _tile_cache[cell] = {
#         "blocking": tile_data.get_custom_data("blocking") if tile_data else false,
#         "source_id": wall_layer.get_cell_source_id(cell)
#     }
#     calculate_fov(ComponentRegistry.get_player_pos())
