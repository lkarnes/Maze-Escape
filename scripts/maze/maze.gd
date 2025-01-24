extends Node


func generate_maze(w, h):
	var maze: Array = [];
	for y in range(h):
		maze.append([])
		for x in range(w):
			maze[y].append(0)
	return maze;
