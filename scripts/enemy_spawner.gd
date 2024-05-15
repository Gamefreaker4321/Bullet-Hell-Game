extends Node2D


var enemy_scene = preload("res://scenes/follow_enemy.tscn")

func _on_timer_timeout():
	for n in 5:
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector2(randi_range(-144,144), position.y)
		add_sibling(enemy)
