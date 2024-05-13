extends CharacterBody2D

const SPEED = 50

var player: Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	if player != null:
		velocity = position.direction_to(player.position) * SPEED
		move_and_slide()
		
