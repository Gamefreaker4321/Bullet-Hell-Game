extends Enemy

var speed = 50
var count = 6
var minions = 4
var player: Node
var jump = true
var locked_dir
var stopped = false
@onready var animated_sprite = $AnimatedSprite2D
@onready var projectile: PackedScene = load("res://scenes/enemy_projectile.tscn")
@onready var audio_player = $AudioStreamPlayer
@onready var level_theme: AudioStreamPlayer =get_node("/root/Game/Level_Music") 
func _ready():
	level_theme.stream_paused = true
	audio_player.play()
func destroy():
	level_theme.stream_paused = false
	queue_free()

func _physics_process(_delta):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	if player != null:
		if stopped == true:
			velocity = Vector2.ZERO
		else: if animated_sprite.animation == "attack":
			velocity = locked_dir * speed * 5
		else:
			velocity = position.direction_to(player.position) * speed
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
	jump = true
	for i in count:
		# rotate 60 degrees
		$origin.rotate(PI/3)
		var inst = projectile.instantiate()
		inst.global_position = $origin/spawn_point.global_position
		inst.delay = 1
		inst.parent = self
		inst.target = player
		inst.id = "slime"
		add_sibling(inst)
		
func jump_attack():
	jump = false
	animated_sprite.animation = "attack"
	locked_dir = position.direction_to(player.position)

func _on_attack_timer_timeout():
	if jump == true:
		jump_attack()
	else:
		shoot() # Replace with function body.

func _on_animated_sprite_2d_frame_changed():
	if animated_sprite && animated_sprite.animation == "attack":
		if animated_sprite.frame > 5:
			stopped = true
		if animated_sprite.frame == 8:
			animated_sprite.animation = "idle"
			stopped = false
			for i in minions:
				# rotate 90 degrees
				$origin.rotate(PI/2)
				var inst = Enemy.new_enemy("slime", 50, 5, 75)
				inst.global_position = $origin/spawn_point.global_position
				add_sibling(inst)
