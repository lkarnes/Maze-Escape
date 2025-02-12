extends Node2D

@export var maze_height: int = 16;
@export var maze_width: int = 16;
@onready var grass: TileMapLayer = %Grass;
var maze_arr;
func _ready():
	# make sure the size is divisible by 4
	if !maze_arr:
		maze_arr = Maze.generate_maze(maze_width, maze_height);
		print('maze 1:', maze_arr)
		maze_arr = Maze.generate_maze_2(maze_width, maze_height);
		print('maze 2:', maze_arr)
		for y in range(maze_arr.size()):
			for x in range(maze_arr[y].size()):
				if maze_arr[y][x] == 0:
					grass.set_cell(Vector2i(x,y), 0, Vector2i(1,1))
				else:
					grass.set_cell(Vector2i(x,y), 0, Vector2i(3,2))
					
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
			position = to_global(Vector2i(x * 16,y * 16))
	return position;
	
	
