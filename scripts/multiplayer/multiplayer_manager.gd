extends Node

const SERVER_PORT = 8080
const SERVER_IP = '127.0.0.1'

@onready var character_scene = preload('res://scenes/Character/Character.tscn')
var _players_spawn_node: Node2D
var maze

func become_host():
	print('Starting host...')
	_players_spawn_node = get_tree().current_scene.get_node('Maze/Players')
	maze = get_tree().current_scene.get_node('Maze')
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	_add_player_to_game(1)


func join():
	print('Player 2 is joining...')
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer


func _add_player_to_game(id: int):
	print('Player %s joined the game!' % str(id))
	
	var player_to_add = character_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	var spawn_position: Vector2i = maze.find_walkable_position()
	print('POS: %s' % str(spawn_position))
	player_to_add.position = spawn_position
	_players_spawn_node.add_child(player_to_add, true)
	
func _del_player(id: int):
	print('Player %s left the game!' % str(id))
	if _players_spawn_node.has_node(str(id)):
		_players_spawn_node.get_node(str(id)).queue_free()
