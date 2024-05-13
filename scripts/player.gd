extends CharacterBody2D

var speed = 150  # speed in pixels/sec
@onready var tile_map := $"../TileMap"

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

func _on_area_2d_body_entered(body):
	print("im here") # Replace with function body.
	var tile_map_layer = 0 
	var tile_map_cell_position = Vector2i(1,-1) 
	var tile_data = tile_map.get_cell_tile_data(tile_map_layer, tile_map_cell_position)
	if tile_data: 
		var tile_map_cell_source_id = tile_map.get_cell_source_id(tile_map_layer, tile_map_cell_position); 
		var tile_map_cell_atlas_coords = tile_map.get_cell_atlas_coords(tile_map_layer, tile_map_cell_position) 
		var tile_map_cell_alternative = tile_map.get_cell_alternative_tile(tile_map_layer, tile_map_cell_position) 
		var new_tile_map_cell_position = tile_map_cell_position + Vector2i.RIGHT 
		tile_map.set_cell(tile_map_layer, new_tile_map_cell_position, tile_map_cell_source_id, tile_map_cell_atlas_coords, tile_map_cell_alternative)


