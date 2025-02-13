extends Node2D

@onready var lobby_id = $LobbyID

func _process(delta: float) -> void:
	pass
func _on_host_pressed() -> void:
	SteamNetwork.become_host()


func _on_join_pressed() -> void:
	var id: int = int(lobby_id.text)
	SteamNetwork.join_as_client(id)
