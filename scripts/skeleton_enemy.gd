extends Enemy

var speed = 50
var count = 8
var sprite_dict = {0: "pumpkin", 1: "skeleton", 2: "werewolf"}
var player: Node
@onready var animated_sprite = $Sprite2D
@onready var projectile: PackedScene = load("res://scenes/enemy_projectile.tscn")
func _ready():
	#var id: int = randi() % 3
	animated_sprite.animation = sprite_dict[1]
	
func destroy():
	queue_free()

func _physics_process(_delta):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	if player != null:
		if position.y > 100:
			velocity = Vector2.UP * speed
		else: if position.y < -100:
			velocity = Vector2.DOWN * speed
		else:
			velocity = Vector2.ZERO
			animated_sprite.animation = "skeleteon_idle"
		if player.position.x > position.x:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
		if move_and_slide():
			var collision = get_last_slide_collision()
			if collision.get_collider() is Player:
				var target = collision.get_collider() as Player
				target.hit(attack)
func shoot():
	for i in count:
		# rotate 45 degrees
		$origin.rotate(0.785398)
		var inst = projectile.instantiate()
		inst.global_position = $origin/spawn_point.global_position
		inst.look_at(player.position)
		inst.delay = 3
		inst.targeted = true
		inst.parent = self
		inst.target = self
		add_sibling(inst)

func _on_attack_timer_timeout():
	shoot() # Replace with function body.
