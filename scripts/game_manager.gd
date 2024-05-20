extends Node

@onready var spawner_top = $"../Enemy_Spawner_Top"
@onready var spawner_bottom = $"../Enemy_Spawner_Bottom"
@onready var spawner_left = $"../Enemy_Spawner_Left"
@onready var spawner_right = $"../Enemy_Spawner_Right"
@onready var prompt = $HUD/Prompts
@onready var zones = $"../Zones"
@onready var player =$"../Player"

var score = Vector2(0,0)

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

func wave1():
	spawner_top.spawn(3, "follow", 200, 0)
	spawner_left.spawn(3, "follow", 0, 200)
	spawner_right.spawn(3, "follow", 0, 200)
	spawner_bottom.spawn(3, "follow", 200, 0)
	spawner_left.spawn(1, "path", 0, 200)
	
func wave2():
	prompt.set_frame_and_progress(1,0)
	pass
	
func wave3():
	pass
	
func wave4():
	pass
	
func wave5():
	pass
	
func wave6():
	pass
	
func wave7():
	pass


func _on_timer_timeout():
	wave1() # Replace with function body.



