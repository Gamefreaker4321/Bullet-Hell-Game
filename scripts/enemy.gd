extends CharacterBody2D

class_name Enemy
var health = 100
var attack = 10

func destroy():
	pass
	
func apply_damage(damage):
	health -= damage
	if health <= 0:
		destroy()

static func new_enemy(name: String, hp: int, att: int) -> Node2D:
	var follow_enemy: PackedScene = load("res://scenes/follow_enemy.tscn")
	var path_enemy: PackedScene = load("res://scenes/path_enemy.tscn")
	var ret
	match name:
		"follow":
			ret = follow_enemy.instantiate()
			ret.health = hp
			ret.attack = att
		"path":
			ret = path_enemy.instantiate()
		#"boss":
			#boss_enemy
	return ret
