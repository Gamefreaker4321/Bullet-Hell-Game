extends Enemy

var player: Node
@onready var projectile: PackedScene = load("res://scenes/enemy_projectile.tscn")

func destroy():
	get_parent().get_parent().queue_free()

func shoot():
	player = get_tree().get_first_node_in_group("Player")
	var inst = projectile.instantiate()
	inst.position = global_position
	inst.look_at(player.position)
	get_tree().root.add_child(inst)

func _on_timer_timeout():
	shoot()
