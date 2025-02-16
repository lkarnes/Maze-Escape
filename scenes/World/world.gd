extends Node2D

@onready var maze = %Maze;
@onready var PLAYER = preload("res://scenes/Character/Character.tscn");
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
	
