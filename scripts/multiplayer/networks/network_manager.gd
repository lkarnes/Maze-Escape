extends Node

@export var _players_spawn_node: Node2D

var lobby_scene := preload('res://scenes/Lobby/Lobby.tscn')
var lobby

func _build_multiplayer_network():
	if not lobby:
		print('Building network...')
		lobby = lobby_scene.instantiate()
		lobby._players_spawn_node = _players_spawn_node
		add_child(lobby)
		MultiplayerManager.multiplayer_mode_enabled = true
	

func become_host():
	_build_multiplayer_network()
	SteamNetwork.become_host()

func join_as_client(lobby_id = 0):
	_build_multiplayer_network()
	SteamNetwork.join_as_client(lobby_id)
	
func list_lobbies():
	_build_multiplayer_network()
	SteamNetwork.list_lobbies()
	
