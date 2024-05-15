extends PathFollow2D

var speed = 150
@onready var sprite = $CharacterBody2D/AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = 0 # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if progress_ratio <= 0:
		sprite.flip_h = false
	else: if progress_ratio >= 1:
		sprite.flip_h = true
	if sprite.flip_h:
		progress = progress - speed * delta
	else: 
		progress = progress + speed * delta
