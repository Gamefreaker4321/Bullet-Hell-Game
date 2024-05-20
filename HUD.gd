extends Node2D

@onready var leftmeter=$"Left Bar"
@onready var rightmeter=$"Right Bar"#$"Right Bar/Wave"
@onready var leftscoreboard=$ScoreLeft
@onready var rightscoreboard=$ScoreRight
@onready var manager=$".."

var scorerequired=200.0
const glyphheight=40

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var score=manager.score
	#rightmeter.set_global_position(score)
	#print(score)
	var percentscore= (score / scorerequired)
	percentscore=percentscore.clamp(Vector2(0,0),Vector2(1,1))
	leftscoreboard.text=str(int(percentscore.x * 100),"%")
	rightscoreboard.text=str(int(percentscore.y * 100),"%")
	leftmeter.set_global_position(Vector2(leftmeter.global_position.x,-(1.0 * percentscore.x * glyphheight)-132))
	rightmeter.set_global_position(Vector2(rightmeter.global_position.x,-(1.0 * percentscore.y * glyphheight)-132))
		
	
	
