extends Node2D

@onready var maze_scene = preload("res://scenes/Maze/Maze.tscn")  # Load the scene
var maze_instance  # Store the instance
var player_spawned = false;


func _ready():
	print("Executing _ready() in world.gd...")
	
	if maze_instance == null:
		print("Instantiating Maze Scene...")
		maze_instance = maze_scene.instantiate()
		add_child(maze_instance)
		print("Maze instance added to scene tree:", maze_instance)

	if maze_instance == null:
		push_error("ERROR: maze_instance is STILL NULL after instantiation in _ready()!")


func _physics_process(delta: float) -> void:
	if !player_spawned:
		player_spawned = true;
<<<<<<< HEAD
		#spawn_players([true])
		
=======
		var player = PLAYER.instantiate();
		player.global_position = maze.find_walkable_position();
		player.trigger_respawn.connect(_on_trigger_respawn);
		add_child(player);

func _on_trigger_respawn(character):
	character.queue_free();
	await get_tree().create_timer(2.0).timeout;
	player_spawned = false;
>>>>>>> dev
	
func spawn_player(player):
	print('FOOBAR!')
	print('Spawning player: %s....' % player)
	
	if maze_instance == null:
		push_error("ERROR: maze_instance is NULL when trying to spawn a player!")
		return  # Prevent further errors

	if not maze_instance.has_method("find_walkable_position"):
		push_error("ERROR: maze_instance does NOT have find_walkable_position method!")
		return

	player.global_position = maze_instance.find_walkable_position()
	add_child(player)
	print('Spawned player successfully: %s' % player)
