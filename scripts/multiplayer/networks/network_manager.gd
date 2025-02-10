extends Node

@export var _players_spawn_node: Node2D

var lobby_scene := preload('res://scenes/Lobby/Lobby.tscn')
var lobby_initialized

func _build_multiplayer_network():
	pass

func _set_active_network():
	lobby_initialized = lobby_scene.instantiate()
	lobby_initialized._players_spawn_node = _players_spawn_node
	add_child(lobby_initialized)

func list_lobbies():
	_build_multiplayer_network()
	SteamNetwork.list_lobbies()
	
