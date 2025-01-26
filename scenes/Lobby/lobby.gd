extends Node2D

@onready var lobby_id = $LobbyID

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_pressed() -> void:
	NetworkImpl.create_lobby()


func _on_join_pressed() -> void:
	var id: int = int(lobby_id.text)
	NetworkImpl.join_lobby(id)
