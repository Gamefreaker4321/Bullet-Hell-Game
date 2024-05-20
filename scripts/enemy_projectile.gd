extends Area2D

class_name Enemy_Projectile

var player
var delay = 0
var speed = 250
var rotate_speed = 10
var fire = false
var targeted = false
var direction
var parent
var target
var id = "default"
@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if delay != 0:
		$DelayTimer.wait_time = delay
		$DelayTimer.start()
	else:
		fire = true
	sprite.animation = id
	direction = transform.x
	body_entered.connect(on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if sprite.frame in [0,1,2]:
		rotation += (rotate_speed * delta)
	if fire:
		position += direction * speed * delta
	else: 
		if parent && is_instance_valid(parent):
			position += parent.velocity * delta
		if target && is_instance_valid(target): 
			direction = position.direction_to(target.global_position)
	
func on_body_entered(body):
	if body is Player:
		player = body as Player
		player.hit(parent.attack)
		queue_free()
	if body is TileMap:
		queue_free()


func _on_timer_timeout():
	fire = true # Replace with function body.
	if targeted == true && is_instance_valid(target):
		direction = position.direction_to(target.global_position)
