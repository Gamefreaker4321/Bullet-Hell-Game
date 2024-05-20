extends Node

@onready var spawner_top = $"../Enemy_Spawner_Top"
@onready var spawner_bottom = $"../Enemy_Spawner_Bottom"
@onready var spawner_left = $"../Enemy_Spawner_Left"
@onready var spawner_right = $"../Enemy_Spawner_Right"

var score = 0
# Called when the node enters the scene tree for the first time.

func add_point():
	score += 1
	print(score)
	
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass #var enemies = get_tree().get_nodes_in_group("Enemy")

func wave1():
	if get_tree().get_nodes_in_group("Elite").size() < 1:
		spawner_bottom.spawn(3, "skeleton", 200, 0, 500)
	if get_tree().get_nodes_in_group("Boss").size() < 1:
		spawner_top.spawn(1, "boss", 0, 0, 10000)
	spawner_left.spawn(2, "follow", 0, 200)
	spawner_right.spawn(2, "follow", 0, 200)
	spawner_bottom.spawn(3, "follow", 200, 0)
	spawner_left.spawn(1, "path", 0, 100)
	spawner_right.spawn(1, "path", 0, 100, 100, 10, 50, true)
	
func wave2():
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
	if get_tree().get_nodes_in_group("Enemy").size() < 15:
		wave1() # Replace with function body.
