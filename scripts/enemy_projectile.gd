extends Area2D

class_name Enemy_Projectile

var speed = 250
var rotate_speed = 10
var initial_transform
@onready var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	var id: int = randi() % 5
	sprite.frame = id
	initial_transform = transform
	body_entered.connect(on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if sprite.frame in [0,1,2]:
		rotation += (rotate_speed * delta)
	position += initial_transform.x * speed * delta
	
func on_body_entered(body):
	if body is Player:
		var player = body as Player
		player.apply_damage(20)
		queue_free()
	if body is TileMap:
		queue_free()


func _on_timer_timeout():
	pass # Replace with function body.
