extends Node2D

@onready var maze = %Maze;
@onready var PLAYER = preload("res://scenes/Character/Character.tscn");
var player_spawned = false;

func _physics_process(delta: float) -> void:
	if !player_spawned:
		player_spawned = true;
		#spawn_players([true])
		
	
func spawn_players(players):
	for player in players:
		print(maze)
		player.global_position = maze.find_walkable_position();
		add_child(player);
