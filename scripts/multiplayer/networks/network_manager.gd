extends Node

@export var _players_spawn_node: Node2D

var world_scene := preload('res://scenes/World/World.tscn')
var world

func _build_multiplayer_network():
	if not world:
		print('Building network...')
		world = world_scene.instantiate()
		#world._players_spawn_node = _players_spawn_node
		#add_child(world)
		MultiplayerManager.multiplayer_mode_enabled = true
		print('Building built successfully!')
		

func become_host():
	_build_multiplayer_network()
	SteamNetwork.become_host()

func join_as_client(lobby_id = 0):
	_build_multiplayer_network()
	SteamNetwork.join_as_client(lobby_id)
	
func list_lobbies():
	_build_multiplayer_network()
	SteamNetwork.list_lobbies()
	
