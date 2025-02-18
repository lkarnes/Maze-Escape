extends Node2D

@onready var maze_scene = preload("res://scenes/Maze/Maze.tscn")  # Load the scene
@onready var PLAYER = preload("res://scenes/Character/Character.tscn");
@onready var maze = %Maze
var player_spawned = false;

func _physics_process(delta: float) -> void:
	if !player_spawned:
		player_spawned = true;
		var player = PLAYER.instantiate();
		player.global_position = maze.find_walkable_position();
		player.trigger_respawn.connect(_on_trigger_respawn);
		add_child(player);

func _on_trigger_respawn(character):
	character.queue_free();
	await get_tree().create_timer(2.0).timeout;
	player_spawned = false;
	
func spawn_player(player):
	print('FOOBAR!')
	print('Spawning player: %s....' % player)
	
	if maze == null:
		push_error("ERROR: maze is NULL when trying to spawn a player!")
		return  # Prevent further errors

	if not maze.has_method("find_walkable_position"):
		push_error("ERROR: maze does NOT have find_walkable_position method!")
		return

	player.global_position = maze.find_walkable_position()
	add_child(player)
	print('Spawned player successfully: %s' % player)
