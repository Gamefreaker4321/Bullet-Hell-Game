extends Node

@onready var spawner_top = $"../Enemy_Spawner_Top"
@onready var spawner_bottom = $"../Enemy_Spawner_Bottom"
@onready var spawner_left = $"../Enemy_Spawner_Left"
@onready var spawner_right = $"../Enemy_Spawner_Right"

@onready var prompt = $HUD/Prompts
@onready var zones = $"../Zones"
@onready var player =$"../Player"

var score = Vector2(0,0)


var wave = 1


# Called when the node enters the scene tree for the first time.

func _on_answer_progress_timeout():
	var selection = zones.get_cell_tile_data(0,zones.local_to_map(player.global_position+(Vector2(292,148)))).get_custom_data("option")
	#print(zones.local_to_map(player.global_position+(Vector2(292,148))))
	#print(zones.map_to_local(player.global_position))
	#var selection =Vector2i(1,0)
	match int(selection.x+selection.y):
		-1:
			add_points(Vector2(1,0))
		1:
			add_points(Vector2(0,1))
	pass # Replace with function body.


func add_points(points):
	score += points
	#print(score)
	
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass #var enemies = get_tree().get_nodes_in_group("Enemy")


func spawn():
	var die = randi()%6
	match wave:
		1:
			spawner_left.spawn(2, "follow", 0, 200)
			spawner_right.spawn(2, "follow", 0, 200)

	
		2:
			prompt.set_frame_and_progress(2,0)
			match die:
				0: spawner_top.spawn(3, "follow", 200, 0)
				1: spawner_left.spawn(2, "follow", 0, 200)
				2: spawner_right.spawn(2, "follow", 0, 200)
				3: spawner_bottom.spawn(3, "follow", 200, 0)
				4: spawner_left.spawn(1, "path", 10, 100)
				5:spawner_right.spawn(1, "path", 10, 100, 100, 10, 40, true)
	
		3:
			spawner_left.spawn(2, "follow", 0, 200)
			spawner_right.spawn(2, "follow", 0, 200)
			if get_tree().get_nodes_in_group("Elite").size() < 1:
				spawner_top.spawn(3, "skeleton", 200, 0, 500)
	
		4:
			if get_tree().get_nodes_in_group("Boss").size() < 1:
				spawner_top.spawn(1, "boss", 0, 0, 100)
	
		5:
			match die:
				0: spawner_top.spawn(3, "follow", 200, 0)
				1: spawner_bottom.spawn(3, "follow", 200, 0)
				2: spawner_left.spawn(3, "path", 10, 100)
				3: spawner_left.spawn(3, "path", 10, 100)
				4: spawner_right.spawn(5, "path", 10, 100, 100, 10, 40, true)
				5: spawner_right.spawn(5, "path", 10, 100, 100, 10, 40, true)
	
		6:
			match die:
				0,1: spawner_left.spawn(8, "path", 10, 100)
				2,3: spawner_right.spawn(8, "path", 10, 100, 100, 10, 40, true)
				4,5: if get_tree().get_nodes_in_group("Elite").size() < 4:
					spawner_top.spawn(3, "skeleton", 200, 0, 500)
					spawner_bottom.spawn(3, "skeleton", 200, 0, 500)
				
		7:
			spawner_left.spawn(3, "path", 10, 100)
			spawner_right.spawn(3, "path", 10, 100, 100, 10, 40, true)
			if get_tree().get_nodes_in_group("Elite").size() < 2:
				spawner_top.spawn(1, "skeleton", 200, 0, 500)
				spawner_bottom.spawn(1, "skeleton", 200, 0, 500)
			if get_tree().get_nodes_in_group("Boss").size() < 1:
				spawner_top.spawn(1, "boss", 0, 0, 10000)

func _on_timer_timeout():

	if get_tree().get_nodes_in_group("Enemy").size() < 15:
		spawn() # Replace with function body.

