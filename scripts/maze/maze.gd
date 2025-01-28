extends Node;

func generate_maze(w, h):
	# Create a minified grid for path generation
	var maze_grid = []
	for y in range(h / 4):
		maze_grid.append([])
		for x in range(w / 4):
			var chunk_obj = {
				"top": 1,
				"right": 1,
				"bottom": 1,
				"left": 1,
				"visited": false,  # Track if the cell is visited
			}
			if y == 0:
				chunk_obj["top"] = null
			if y == (h / 4) - 1:
				chunk_obj["bottom"] = null
			if x == 0:
				chunk_obj["left"] = null
			if x == (w / 4) - 1:
				chunk_obj["right"] = null
			maze_grid[y].append(chunk_obj)
	
	# Carve paths in the maze grid
	var start_coords = Vector2i(0, 0) # Start carving from the top-left corner
	var stack = []
	carve_path_recursive_dfs(start_coords, stack, maze_grid, null)
	
	var maze: Array = []
	for y in range(h + 1):
		maze.append([])
		for x in range(w + 1):
			# Create walls at specific intervals
			if x % 4 == 0 or y % 4 == 0 or x == w or y == h:
				maze[y].append(1)
			else:
				maze[y].append(0)
				
	# Apply the maze grid to the maze array
	for y in range(maze_grid.size()):
		for x in range(maze_grid[y].size()):
			var cell = maze_grid[y][x]
			# Calculate the top-left corner of the current 4x4 chunk in the maze
			var base_y = y * 4
			var base_x = x * 4
			
			# Carve the cell itself
			maze[base_y + 2][base_x + 2] = 0
			# Carve paths based on the directions
			if cell["top"] == 0:
				# Open top wall
				maze[base_y][base_x + 2 - 1] = 0;
				maze[base_y][base_x + 2] = 0 
				maze[base_y][base_x + 2 + 1] = 0 
			if cell["right"] == 0:
				# Open right wall	
				maze[base_y + 2 - 1][base_x + 4] = 0
				maze[base_y + 2][base_x + 4] = 0
				maze[base_y + 2 + 1][base_x + 4] = 0
			if cell["bottom"] == 0:
				# Open bottom wall
				maze[base_y + 4][base_x + 2 - 1] = 0
				maze[base_y + 4][base_x + 2] = 0
				maze[base_y + 4][base_x + 2 + 1] = 0
			if cell["left"] == 0:
				# Open left wall
				maze[base_y + 2 - 1][base_x] = 0
				maze[base_y + 2][base_x] = 0
				maze[base_y + 2 + 1][base_x] = 0
	return maze;

func carve_path_recursive_dfs(current_coords: Vector2i, stack, maze_grid, rollback_dir):
	if rollback_dir:
		print(current_coords);
		maze_grid[current_coords.y][current_coords.x][rollback_dir] = 0;
	var current = maze_grid[current_coords.y][current_coords.x]
	if current["visited"] && stack.size() > 0:
		var previous_coords = stack.pop_back();
		var new_rollback_dir;
		if previous_coords.x + 1 <= maze_grid[previous_coords.y].size() - 1:
			new_rollback_dir = "right"
		elif previous_coords.x - 1 > 0:
			new_rollback_dir = "left";
		elif previous_coords.y + 1 <= maze_grid.size():
			new_rollback_dir = "top";
		elif previous_coords.y - 1 > 0:
			new_rollback_dir = "bottom";
		carve_path_recursive_dfs(previous_coords, stack, maze_grid, new_rollback_dir);
	
	# Mark current tile as visited
	current["visited"] = true;
	
	var valid_directions = []
	if current["left"] and not maze_grid[current_coords.y][current_coords.x - 1]["visited"]:
		valid_directions.append("left")
	if current["right"] and not maze_grid[current_coords.y][current_coords.x + 1]["visited"]:
		valid_directions.append("right")
	if current["top"] and not maze_grid[current_coords.y - 1][current_coords.x]["visited"]:
		valid_directions.append("top")
	if current["bottom"] and not maze_grid[current_coords.y + 1][current_coords.x]["visited"]:
		valid_directions.append("bottom")
	
	if valid_directions.size() == 0:
		# Decide probabilistically whether to revisit a tile
		if stack.size() == 0:  # 50% chance to stop backtracking
			return
		var previous_coords = stack.pop_back()
		var new_rollback_dir;
		if previous_coords.x + 1 <= maze_grid[previous_coords.y].size() - 1:
			new_rollback_dir = "right"
		elif previous_coords.x - 1 > 0:
			new_rollback_dir = "left";
		elif previous_coords.y + 1 <= maze_grid.size():
			new_rollback_dir = "top";
		elif previous_coords.y - 1 > 0:
			new_rollback_dir = "bottom";
		carve_path_recursive_dfs(previous_coords, stack, maze_grid, new_rollback_dir);
		return;
	
	# Choose a random direction to carve
	var direction = valid_directions.pop_at(randi_range(0, valid_directions.size() - 1))
	
	if valid_directions.size() > 0:
		for dir in valid_directions:
			stack.append(get_next_position_by_direction(dir, current_coords));
	
	var next_coords = get_next_position_by_direction(direction, current_coords);
	
	# Open the current direction
	current[direction] = 0
	
	# Open the opposite direction in the next cell
	var opposite_direction = get_opposite_direction(direction)
	maze_grid[next_coords.y][next_coords.x][opposite_direction] = 0
	
	# Recur for the next position
	carve_path_recursive_dfs(next_coords, stack, maze_grid, null)

# Get the next position based on the direction
func get_next_position_by_direction(direction: String, current_coords: Vector2i) -> Vector2i:
	var next = current_coords
	if direction == "top":
		next.y -= 1
	elif direction == "right":
		next.x += 1
	elif direction == "bottom":
		next.y += 1
	elif direction == "left":
		next.x -= 1
	return next

# Get the opposite direction for carving paths
func get_opposite_direction(direction: String) -> String:
	match direction:
		"top":
			return "bottom"
		"right":
			return "left"
		"bottom":
			return "top"
		"left":
			return "right"
	return ""
