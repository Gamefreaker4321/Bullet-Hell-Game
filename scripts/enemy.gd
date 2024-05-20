extends CharacterBody2D

class_name Enemy
var health = 100
var attack = 10
static var follow_enemy: PackedScene = load("res://scenes/follow_enemy.tscn")
static var path_enemy: PackedScene = load("res://scenes/path_enemy.tscn")

static var skeleton_enemy: PackedScene = load("res://scenes/skeleton_enemy.tscn")
static var slime_king: PackedScene = load("res://scenes/slime_king_enemy.tscn")


func destroy():
	pass
	
func apply_damage(damage):
	health -= damage
	if health <= 0:
		destroy()


static func new_enemy(name: String, hp: int, att: int, spd: int = 40) -> Node2D:

	var ret
	match name:
		"follow":
			ret = follow_enemy.instantiate()
			ret.health = hp
			ret.attack = att
			ret.speed = spd
		"slime":
			ret = follow_enemy.instantiate()
			ret.health = hp
			ret.attack = att
			ret.id = 2
			ret.speed = spd
		"skeleton":
			ret = skeleton_enemy.instantiate()
			ret.health = hp
			ret.attack = att
			ret.speed = spd
		"boss":
			ret = slime_king.instantiate()
			ret.health = hp
			ret.attack = att
			ret.speed = spd
			ret.scale *= 3
		"path":
			ret = path_enemy.instantiate()
	return ret
