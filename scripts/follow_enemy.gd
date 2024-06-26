extends Enemy

var speed = 35
var id
var sprite_dict = {0: "pumpkin", 1: "werewolf", 2: "slime", 3:"goblin"}
var player: Node
@onready var animated_sprite = $Sprite2D
@onready var projectile: PackedScene = load("res://scenes/enemy_projectile.tscn")
@onready var zones= get_node("/root/Game/Zones")

#signal follow_die

func _ready():
	if !id:
		id = randi() % 4
	animated_sprite.animation = sprite_dict[id]
	#var dead = Signal(self,"follow_die")
	#if!(dead.is_connected(on_enemy_death_trigger)):
	#	self.connect("follow_die",on_enemy_death_trigger)

func destroy():
	zones.on_enemy_death_trigger(global_position,animated_sprite.animation)
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
