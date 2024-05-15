extends CharacterBody2D

class_name Enemy
var health = 100

func destroy():
	pass
	
func apply_damage(damage):
	health -= damage
	if health <= 0:
		destroy()
