extends Control

@onready var lobby_id = $LobbyID

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/World/World.tscn")

func _on_host_button_pressed():
	NetworkImpl.create_lobby()

func _on_join_button_pressed():
	var id: int = int(lobby_id.text)
	NetworkImpl.join_lobby(id)


func _on_exit_button_pressed():
	get_tree().quit()
