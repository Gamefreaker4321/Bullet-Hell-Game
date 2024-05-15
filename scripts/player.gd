extends CharacterBody2D

class_name Player

const COOLDOWN = 10
const IFRAMES = 10

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

func _ready():
	health_bar.visible = false
	
func _physics_process(_delta):
	if iframes < IFRAMES:
		iframes += 1
	if timer > 0:
		timer -= 1
	var direction = Input.get_vector("left", "right", "up", "down")
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
			timer = COOLDOWN 
			shoot(last_direction)
	
func shoot(direction):
	var inst = projectile.instantiate()
	inst.position = global_position
	inst.look_at(global_position + direction)
	var left = inst.duplicate()
	left.rotate(0.26)
	var right = inst.duplicate()
	right.rotate(-0.26)
	add_sibling(left)
	add_sibling(inst)
	add_sibling(right)

func hit(damage):
	if iframes >= IFRAMES:
		iframes = 0
		health -= damage
		health_bar.value = health
		health_bar.visible = true
		health_timer.start()
		if health <= 0 && death_timer.is_stopped():
			sprite.animation = "death" 
			death_timer.start()
			print("dying")

func _on_death_timer_timeout():
	get_tree().reload_current_scene() # Replace with function body.


func _on_health_timer_timeout():
	health_bar.visible = false
