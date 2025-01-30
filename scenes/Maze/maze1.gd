extends Node2D

@onready var grass: TileMapLayer = %Grass;
var maze_arr;
func _physics_process(delta: float):
	# make sure the size is divisible by 4
	if !maze_arr:
		maze_arr = Maze.generate_maze(64, 64);
		for y in range(maze_arr.size()):
			print(maze_arr[y]);
			for x in range(maze_arr[y].size()):
				if maze_arr[x][y] == 0:
					grass.set_cell(Vector2i(x,y), 0, Vector2i(1,1))
				else:
					grass.set_cell(Vector2i(x,y), 0, Vector2i(3,2))
	
