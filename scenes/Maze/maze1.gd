extends Node2D

@export var maze_height: int = 80;
@export var maze_width: int = 80;
@onready var grass: TileMapLayer = %Grass;
@onready var walls: TileMapLayer = %Walls;
var maze_arr;
func _ready():
	# make sure the size is divisible by 4
	if !maze_arr:
		#maze_arr = Maze.generate_maze(maze_width, maze_height);
		#print('maze 1:', maze_arr)
		maze_arr = Maze.generate_maze_2(maze_width, maze_height);
		# print('maze 2:', maze_arr)
		
		for y in range(maze_height * 3):
			for x in range(maze_width * 3):
					grass.set_cell(Vector2i(x,y), 0, Vector2i(1,1))
		
		for y in range(maze_arr.size()):
			for x in range(maze_arr[y].size()):
				
				if maze_arr[y][x] == 1:
					grass.set_cell(Vector2i(x * 3,y * 3), 0, Vector2i(3,2))
					grass.set_cell(Vector2i(x * 3,y * 3), 0, Vector2i(0,0))
					walls.set_cell(Vector2i(x * 3,y * 3), 0, Vector2i(0,0))
					
					# fill y gaps
					if y > 1 and maze_arr[y - 1][x] == 1:
						grass.set_cell(Vector2i(x * 3,(y * 3) - 1), 0, Vector2i(3,2))
						grass.set_cell(Vector2i(x * 3,(y * 3) - 2), 0, Vector2i(3,2))
						walls.set_cell(Vector2i(x * 3,(y * 3) - 1), 0, Vector2i(0,0))
						walls.set_cell(Vector2i(x * 3,(y * 3) - 2), 0, Vector2i(0,0))
					if y + 1 < maze_arr.size() and maze_arr[y + 1][x] == 1:
						grass.set_cell(Vector2i(x * 3,(y * 3) + 1), 0, Vector2i(3,2))
						grass.set_cell(Vector2i(x * 3,(y * 3) + 2), 0, Vector2i(3,2))
#					# fill x gaps
					if x + 1 < maze_arr[y].size() and maze_arr[y][x + 1] == 1:
						grass.set_cell(Vector2i((x * 3) + 1,y * 3), 0, Vector2i(3,2))
						grass.set_cell(Vector2i((x * 3) + 2,y * 3), 0, Vector2i(3,2))
						walls.set_cell(Vector2i((x * 3) + 1,y * 3), 0, Vector2i(0,0))
						walls.set_cell(Vector2i((x * 3) + 2,y * 3), 0, Vector2i(0,0))
					if x > 0 and maze_arr[y][x - 1] == 1:
						grass.set_cell(Vector2i((x * 3 - 1),y * 3), 0, Vector2i(3,2))
						grass.set_cell(Vector2i((x * 3 - 2),y * 3), 0, Vector2i(3,2))
						
					
func find_walkable_position() -> Vector2i:
	var position: Vector2i;
	var found_valid_position = false;
	var z = 0;
	var idx = 0;
	var limit = 1000;
	while !found_valid_position && idx < limit:
		idx += 1;
		var x = randi_range(0, maze_width);
		var y = randi_range(0, maze_height)
		
		if maze_arr[y][x] == 0:
			found_valid_position = true;
			position = to_global(Vector2i(x * 16 * 3,y * 16 * 3))
	return position;
	
	
