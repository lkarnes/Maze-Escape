extends Node

var multiplayer_scene = preload('res://scenes/Lobby/Lobby.tscn')
var multiplayer_peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var _players_spawn_node
var _hosted_lobby_id = 0

const LOBBY_NAME = "Maze Escape"

func _ready():
	Steam.lobby_created.connect(_on_lobby_created.bind())

func become_host():
	print('Starting host!')
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	Steam.lobby_joined.connect(_on_lobby_joined.bind())
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, SteamManager.lobby_max_members)
	

func join_as_client(lobby_id):
	print('Joining lobby %s' % lobby_id)
	
	Steam.lobby_joined.connect(_on_lobby_joined.bind())
	Steam.joinLobby(int(lobby_id))
	
func _on_lobby_joined(lobby: int, permissions: int, locked: bool, response: int):
	print('On lobby joined')
	if response == 1:
		var id = Steam.getLobbyOwner(lobby)
		if id != Steam.getSteamID():
			print('Connecting client to socket...')
			connect_socket(id) 
	else:
		pass
		
func connect_socket(steam_id: int):
	var res = multiplayer_peer.create_client(steam_id, 0)
	if res == OK:
		print('Connecting peer to host...')
		multiplayer.set_multiplayer_peer(multiplayer_peer)
	else:
		print('Error creating client: %s' % str(res))
		
func _on_lobby_created(connect: int, lobby_id):
	if connect == 1:
		_hosted_lobby_id = lobby_id
		print("Created lobby: %s" % _hosted_lobby_id)
		
		Steam.setLobbyJoinable(_hosted_lobby_id, true)
		Steam.setLobbyData(_hosted_lobby_id, "name", LOBBY_NAME)
		
		_create_host()
		
func _create_host():
	print('Creating host...')
	var res = multiplayer_peer.create_host(0)
	if res == OK:
		multiplayer.set_multiplayer_peer(multiplayer_peer)
		
		if not OS.has_feature('dedicated_server'):
			_add_player_to_game(1)
		else:
			print('Error creating host: %s' % str(res))
			
func list_lobbies():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	# NOTE: If you are using the test app id, you will need to apply a filter on your game name
	# Otherwise, it may not show up in the lobby list of your clients
	Steam.addRequestLobbyListStringFilter("name", LOBBY_NAME, Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()

func _add_player_to_game(id: int):
	print('Player %s is ready to face the MAZE!', %id)
	
	var player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	_players_spawn_node.add_child(player_to_add, true)

func _del_player(id: int):
	print('Player %s is too cowardly to face the MAZE!' % id)
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()
