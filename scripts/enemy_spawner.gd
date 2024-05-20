extends Node2D

func spawn(count: int, type: String, randx: int, randy:int, hp: int = 100, att: int = 10, spd: int = 50, flip: bool = false):
	var spread_x
	var spread_y
	if randx != 0:
		spread_x = range(-randx, randx, 2*randx/(count+1))
	if randy != 0:
		spread_y = range(-randy, randy, 2*randy/(count+1))
	for n in count:
		var enemy = Enemy.new_enemy(type, hp, att, spd)
		var x
		var y
		if randx == 0:
			x = 0
		else:
			x = randf_range(spread_x[n],spread_x[n+1])
		if randy == 0:
			y = 0
		else:
			y = randf_range(spread_y[n],spread_y[n+1])
		enemy.position = position + Vector2(x,y)
		if flip:
			enemy.scale.x = -1
		add_sibling(enemy)
