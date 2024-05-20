extends TileMap

@onready var timer = $"../ZoneTimer"
@onready var tile_map := $"../Zones"

const map_h = 74 #size of map in tiles
const map_w = 146

const tile_size=4 #size of tile in pixels



#tested with 2.5, 6 with thresh of 6,10
#const thresh_low = 10
#const thresh_high= 70

const layer=0
const tilesid=1
const useproxy=0

const sample_size=[int(-1),int(0),int(1)] #currrent ranges require sampling to be -1,0,1 since cell rules are only defined in ranges that assume those values



func make_2d_array(width, height, fill):
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(fill);
	return array;

var arrayupdates = make_2d_array(map_w,map_h, Vector2(0,0))
var tiles = make_2d_array(map_w,map_h,Vector2i()) #current tiles
var tiles_next = make_2d_array(map_w,map_h,int(0)) #next set of tiles based on arrayupdates
#process is to 
#1 iterate through tiles and map sums into arrayupdates, 
#2 then set tiles_next according to threshholds
#3 then apply changes to the tiles once all are read

var pattern_dia_a #dark green diamond
var pattern_dia_b #dark purple diamond


func _ready():
	#$"res://scenes/follow_enemy.tscn".connect("follow_die",on_enemy_death_trigger)
	tiles_next = make_2d_array(map_w,map_h,int(0))
	#print(tiles_next)
	#create tile patterns for enemy drops later
	pattern_dia_a = TileMapPattern.new()
	pattern_dia_a.set_size(Vector2i(7,7))
	for x in 7:
		for y in 7:
			if (((x+y) <= 9) && ((x+y)>=3) && ((abs(x-y)<=3))): #should create a diamond
				pattern_dia_a.set_cell(Vector2i(x,y),tilesid, Vector2i(0,0), 0)
			elif (pattern_dia_a.has_cell(Vector2i(x,y))):
				pattern_dia_a.remove_cell(Vector2i(x,y),false)
			
	pattern_dia_b = TileMapPattern.new()
	pattern_dia_b.set_size(Vector2i(7,7))
	for x in 7:
		for y in 7:
			if (((x+y) <= 9) && ((x+y)>=3) && ((abs(x-y)<=3))): #should create a diamond
				pattern_dia_b.set_cell(Vector2i(x,y),tilesid, Vector2i(3,0), 0)
			elif (pattern_dia_b.has_cell(Vector2i(x,y))):
				pattern_dia_b.remove_cell(Vector2i(x,y),false)
	

	#this section randomly initializes the starting play area
	var rng=RandomNumberGenerator.new()
	rng.randomize()
	for i in map_w:
		for j in map_h:
			if (rng.randi() %100)>30:
				tiles_next[i][j]=rng.randi_range(0,3)
				#print(tiles_next[i][j])
			else:
				var tile=tile_map.get_cell_tile_data(layer,Vector2i(i,j), useproxy).get_custom_data("option")
				#print(tile)
				match tile.x+tile.y:
					-1:
						tiles_next[i][j]=1
					1:
						tiles_next[i][j]=2
				#print(tiles_next[i][j])
			#print("[",i,"][",j,"]", tiles_next[i][j])
			
	for k in 12:
		#smoothing
		for i in map_w:
			for j in map_h:
				if (i-1 >=0 && i+1 < map_w && j-1 >= 0 && j+1 <map_h):#cell is in bounds *breaks if field has empty cells*
					match (tiles_next[i-1][j-1]+tiles_next[i-1][j]+tiles_next[i-1][j+1]+tiles_next[i][j-1]+tiles_next[i][j]+tiles_next[i][j+1]+tiles_next[i+1][j-1]+tiles_next[i+1][j]+tiles_next[i+1][j+1]):
						2,3,4,5,6,7,8,9:
							arrayupdates[i][j]=Vector2(0,0)
						10,11,12,13:
							arrayupdates[i][j]=Vector2(1,0)
						14,15,16,17:
							arrayupdates[i][j]=Vector2i(2,0)
						18,19,20,21,22,23,24,25:
							arrayupdates[i][j]=Vector2(3,0)
				else:
					arrayupdates[i][j]=Vector2(rng.randi_range(1,2),0)
						
		for i in map_w: #set the cells, this breaks when called inside the loops that get and prepare the cell data
			for j in map_h:
				#print (tiles_next[i][j])
				if (tiles_next[i][j] >= 0):
					tiles_next[i][j]=int(arrayupdates[i][j].x)
				else:
					tiles_next[i][j]=rng.randi_range(1,2)
				
					
	#_clean_tiles_before_update()
	_update_tiles(1)
	#arrayupdates = make_2d_array(map_w,map_h, Vector2(0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func convert_coord(position):
	#takes Vector2 position, maps to Vector2i in tile coordinates
	return Vector2i(floor(position.x/tile_size),floor(position.y/tile_size)) #Using a Vector2 as a constructor for a Vector2i rounds towards 0 which is ideal here

func _drop_zone(position, pattern, offset):
	#takes vector2i position and int pattern
	#sets tiles at that position to match the pattern type
	#print(pattern)
	#define patterns
	tile_map.set_pattern(layer,position+offset,pattern)
	
	
func on_enemy_death_trigger(position,id):
	print("AAAAAAA")
	#takes enemy, makes calls to any map changes
	if id in(["pumpkin","skeleton"]) :
		#0:
			_drop_zone(convert_coord(position+(Vector2(292,148))), pattern_dia_a, Vector2i(-3,-3))
	else:
			_drop_zone(convert_coord(position++(Vector2(292,148))), pattern_dia_b, Vector2i(-3,-3))


func _on_timer_timeout():
		#_drop_zone(Vector2i(map_w,map_h),pattern_dia_a, Vector2i(0,0))
		_get_next_tiles()
		_update_tiles()
	#tile_map.set_cell(layer, Vector2i(0,0), 0, Vector2i(1,0))
	#pass
func _update_tiles(force=0):
	for i in map_w: #set the cells, this breaks when called inside the loops that get and prepare the cell data
		for j in map_h:
			if(force):
				#clamp(tiles_next[i][j],1,2)
				tiles_next[i][j]=_clean_tiles_before_update(tiles_next[i][j])
			if (tiles_next[i][j] >= 0):
				tile_map.set_cell(layer, Vector2i(i,j), tilesid, Vector2i(tiles_next[i][j],0))
			

func _clean_tiles_before_update(tile):
	#for i in map_w:
			#for j in map_h:
				#print("i1 ",i,"j1 ",j,"t",tiles_next[i][j])
				#if (tiles_next[i][j]==0):
				#	tiles_next[i][j]=1
				#if (tiles_next[i][j]==3):
				#	tiles_next[i][j]=2
				
				if tile==0:
					return 1
				elif tile==3:
					return 2
				else:
					return tile
				
				
				
				#match tiles_next[i][j]:
				#	0:
				#		tiles_next[i][j]=1
				#	3:
				#		tiles_next[i][j]=2
				#print ("i2 ",i,"j2 ",j,"t ",tiles_next[i][j])

func _map_ranges(sum):
	#takes vector2, returns int
	#sorts groups of result tiles into rule sets
	#this implementation is kinda nasty as these if statements need to be completely rewritten to make a rules change
	#kind of impossible to explain without visual chart
	#might be replaced with an algebraic form later to get smoother results but chaotic elements are needed and would have to also be implemented
	
	
	const dropoff1=4
	const dropoff2=5
	
	
	var rng=RandomNumberGenerator.new() #used to keep dark patches from becoming too overpoweringly dark, allow coinflips into brighter color
	rng.randomize()
	#print(sum)
	
	if (sum.x<=-9):
		var roll= (rng.randi_range(0,dropoff1))
		if (sum.x==-10 && roll==0) || roll<=1:
			return 0
		else:
			return 1
	elif(sum.x+sum.y<=-6):
		var roll= (rng.randi_range(0,dropoff2))
		if (sum.x>=-2):
			return 1
		elif roll==0:
			return 1
		else:
			return 0
	elif(sum.x<= -1 && sum.y<= 5):
		return 1
	elif ((sum.x==2 && sum.y==-6)||(sum.x==-4 && sum.y==6)):
		return 1
	
	elif(sum.x>=9):
		var roll= (rng.randi_range(0,dropoff1))
		#print (roll)
		if (sum.x==10 && roll==0) || roll<=1:
			return 3
		else:
			return 2
	elif(sum.x+sum.y>=6):
		var roll= (rng.randi_range(0,dropoff2))
		if (sum.x<=2):
			return 2
		elif roll==0:
			return 2
		else:
			return 3
	elif(sum.x>= 1 && sum.y>= -5):
		return 2
	elif ((sum.x==-2 && sum.y==6)||(sum.x==4 && sum.y==-6)):
		return 2
	
	else:
		return -1
	
	"""
#old algebraic rules, using sum as an int and treating dark tiles as worth 6, light tiles as worth 2.5, with thresholds at 6 and 10 (tile values plus or minus)
	if (sum>thresh_high):
		return 3
	elif (sum>thresh_low):
		return 2
	elif (sum< -1*thresh_high):
		return 0
	elif (sum< -1*thresh_low):
		return 1
	else:
		return -1
	"""

func _get_next_tiles():
	
	#iterate through tiles and
	
	#step 1-iterate through tiles and map sums
	#get current tiles
	#map sums
	#contains summed weights being used to determine what a tile changes to
	for i in map_w:
		for j in map_h:
			if tile_map.get_cell_tile_data(layer,Vector2i(i,j), useproxy):
				arrayupdates[i][j]=tile_map.get_cell_tile_data(layer,Vector2i(i,j), useproxy).get_custom_data("option") #this adds an extra copy of the current center tile so it is weighed heavier
				for surround_x in sample_size:
					for surround_y in sample_size:
						#print ("i=" , i , " j=" , j , " surround_x=" ,surround_x , " surround_y=" ,surround_y)
						if (i+surround_x >=0 && i +surround_x < map_w && j+surround_y >= 0 && j+surround_y <map_h):#cell is in bounds *breaks if field has empty cells*
								#current behavior "prefers squares" rather than circles - ideal fix increases sample size and adjusts weight based on distance from center but would require changes to cell rules to be more algebra and less hardcoded rules
								#if there is time that would be nice but would also need to figure out a way to make the behavior just a little bit chaotic to keep tiles moving
								arrayupdates[i][j] +=tile_map.get_cell_tile_data(layer,Vector2i(i+surround_x,j+surround_y), useproxy).get_custom_data("option")
						else:#use current block instead at borders , may change this behavior later to be smoother
							arrayupdates[i][j]+=tile_map.get_cell_tile_data(layer,Vector2i(i,j), useproxy).get_custom_data("option")
								#print(tile_map.get_cell_tile_data(layer,Vector2i(i+surround_x,j+surround_y), useproxy).get_custom_data("option"))
								#step 2 set tiles_next
			#var mapped_value=_map_ranges(arrayupdates[i][j])
			tiles_next[i][j]=_map_ranges(arrayupdates[i][j])
			#print (tiles_next[i][j])

	#set tiles_next
	


