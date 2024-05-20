extends CharacterBody2D

class_name Player

const COOLDOWN = 14
const IFRAMES = 10

var shotgun = true
var turbo = true
var speed_boost = false
var penetrate = true
var power_shot = false

var speed = 150  # speed in pixels/sec
var health = 100
var iframes = 0
var timer = 0
var last_direction = Vector2.RIGHT
	
@onready var tile_map = $"../TileMap"
@onready var death_timer = $DeathTimer
@onready var sprite = $PlayerSprite
@onready var health_bar = $HealthBar
@onready var health_timer = $HealthTimer
@export var projectile : PackedScene
@onready var audio_player = $AudioStreamPlayer


func _ready():
	health_bar.visible = true
	
func _physics_process(_delta):
	if iframes < IFRAMES:
		iframes += 1
	if timer > 0:
		timer -= 1
	var direction = Input.get_vector("left", "right", "up", "down")
	if speed_boost:
		velocity = direction * speed * 2
	else:
		velocity = direction * speed
	if velocity.x > 0:
		sprite.flip_h = false
	if velocity.x < 0:
		sprite.flip_h = true
	if death_timer.is_stopped():
		move_and_slide()
		if direction != Vector2.ZERO:
			last_direction = direction
		if Input.is_action_pressed("fire") && timer == 0:
			if turbo:
				timer = COOLDOWN/2
			else:
				timer = COOLDOWN  
			shoot(last_direction)
	
func shoot(direction):
	var inst = projectile.instantiate()
	inst.position = global_position
	inst.look_at(global_position + direction)
	audio_player.play()
	if speed_boost:
		inst.speed *= 2
	if penetrate:
		inst.penetrate = 2
		inst.id = 3
	if power_shot:
		inst.damage *= 2
		inst.id = 4
	add_sibling(inst)
	if shotgun:
		# add 15% spread
		var left = inst.duplicate()
		left.rotate(0.26)
		var right = inst.duplicate()
		right.rotate(-0.26)
		if speed_boost:
			left.speed *= 2
			right.speed *= 2
		if penetrate:
			left.penetrate = 2
			right.penetrate = 2
			left.id = 3
			right.id = 3
		if power_shot:
			left.damage *= 2
			right.damage *= 2
			left.id = 4
			right.id = 4
		add_sibling(left)
		add_sibling(right)

func hit(damage):
	if iframes >= IFRAMES:
		iframes = 0
		health -= damage
		health_bar.value = health
		if health <= 0 && death_timer.is_stopped():
			sprite.animation = "death" 
			death_timer.start()
			print("dying")

func _on_death_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn") # Replace with function body.
