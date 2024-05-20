extends Enemy

var speed = 50

var sprite_dict = {0: "pumpkin", 1: "skeleton", 2: "werewolf"}
var player: Node
@onready var animated_sprite = $Sprite2D
@onready var projectile: PackedScene = load("res://scenes/enemy_projectile.tscn")
func _ready():
	var id: int = randi() % 3
	animated_sprite.animation = sprite_dict[id]
	
func destroy():
	
	queue_free()

func _physics_process(_delta):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	if player != null:
		velocity = position.direction_to(player.position) * speed
		if velocity.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
		if move_and_slide():
			var collision = get_last_slide_collision()
			if collision.get_collider() is Player:
				var target = collision.get_collider() as Player
				target.hit(attack)
func shoot():
	var inst = projectile.instantiate()
	inst.position = global_position
	inst.look_at(player)
	add_sibling(inst)
