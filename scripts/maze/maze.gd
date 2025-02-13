extends Node;

	
# Generates a maze using Kruskal's Algorithm
func generate_maze_2(w, h):
	var maze = []
	for y in range(h + 1):
		maze.append([])
		for x in range(w + 1):
			maze[y].append(1)  # Default to walls

	# Convert grid into a list of edges
	var edges = []
	var cells = []
	var dsu = {}  # Disjoint set to track connected components

	for y in range(1, h, 2):
		for x in range(1, w, 2):
			cells.append(Vector2i(x, y))
			dsu[Vector2i(x, y)] = Vector2i(x, y)  # Initialize DSU
			if x + 2 < w:
				edges.append([Vector2i(x, y), Vector2i(x + 2, y)])
			if y + 2 < h:
				edges.append([Vector2i(x, y), Vector2i(x, y + 2)])

	# Shuffle edges for randomization
	edges.shuffle()
	
	# Apply Kruskal's Algorithm
	for edge in edges:
		var cell1 = edge[0]
		var cell2 = edge[1]
		if find(cell1, dsu) != find(cell2, dsu):
			union(cell1, cell2, dsu)
			maze[cell1.y][cell1.x] = 0
			maze[cell2.y][cell2.x] = 0
			# Remove wall between cells
			var wall_x = (cell1.x + cell2.x) / 2
			var wall_y = (cell1.y + cell2.y) / 2
			maze[wall_y][wall_x] = 0

	return maze

	
func find(v, sets):
	if sets[v] != v:
		sets[v] = find(sets[v], sets)
	return sets[v]
	
func union(v1, v2, sets):
	sets[find(v1, sets)] = find(v2, sets)
