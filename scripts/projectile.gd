extends Area2D

var speed = 250
var rotate_speed = 10
var penetrate = 1
var id = 0
var damage = 50

var initial_transform
@onready var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if id == 0:
		id = randi() % 3
	sprite.frame = id
	initial_transform = transform
	body_entered.connect(on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if sprite.frame in [0,1,2]:
		rotation += (rotate_speed * delta)
	position += initial_transform.x * speed * delta

func on_body_entered(body):
	if body is Enemy:
		var enemy = body as Enemy
		enemy.apply_damage(damage)
		penetrate -= 1
		if penetrate == 0:
			queue_free()
			
	if body is TileMap:
		queue_free()
