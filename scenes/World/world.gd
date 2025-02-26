extends Node2D

@onready var maze = %Maze;

func _physics_process(delta: float) -> void:
	pass

func _on_trigger_respawn(character):
	character.queue_free();
	await get_tree().create_timer(2.0).timeout;
