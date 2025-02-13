extends Node2D

@onready var lobby_id = $LobbyID

func _process(delta: float) -> void:
	NetworkManager._build_multiplayer_network()
func _on_host_pressed() -> void:
	NetworkManager.become_host()


func _on_join_pressed() -> void:
	var id: int = int(lobby_id.text)
	NetworkManager.join_as_client(id)
