extends Node

@onready var character_scene = preload('res://scenes/Character/Character.tscn')
@onready var world = preload("res://scenes/World/World.tscn");
var world_instance
@onready var world_script = preload("res://scenes/World/world.gd");
var multiplayer_peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var _players_spawn_node
var _hosted_lobby_id = 0

const LOBBY_NAME = "Maze Escape"

func _ready():
	#if not world_instance:
		#world_instance = world.instantiate()
	SteamManager.initialize_steam()
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)

func become_host():
	print('Starting host!')
	
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, SteamManager.lobby_max_members)

func join_as_client(lobby_id):
	print('Joining lobby %s' % lobby_id)
	
	Steam.joinLobby(int(lobby_id))
	
func _on_lobby_joined(lobby: int, permissions: int, locked: bool, response: int):
	print('On lobby joined')
	if response == 1:
		print('SUCCESSFUL CONNECTION TO LOBBY!')
		var id = Steam.getLobbyOwner(lobby)
		if id != Steam.getSteamID():
			print('Connecting client to socket...')
			connect_socket(id) 
	else:
		print('FAILED CONNECTION TO LOBBY!')
		# Get the failure reason
		var FAIL_REASON: String
		match response:
			2:  FAIL_REASON = "This lobby no longer exists."
			3:  FAIL_REASON = "You don't have permission to join this lobby."
			4:  FAIL_REASON = "The lobby is now full."
			5:  FAIL_REASON = "Uh... something unexpected happened!"
			6:  FAIL_REASON = "You are banned from this lobby."
			7:  FAIL_REASON = "You cannot join due to having a limited account."
			8:  FAIL_REASON = "This lobby is locked or disabled."
			9:  FAIL_REASON = "This lobby is community locked."
			10: FAIL_REASON = "A user in the lobby has blocked you from joining."
			11: FAIL_REASON = "A user you have blocked is in the lobby."
		print(FAIL_REASON)
		
func connect_socket(steam_id: int):
	var res = multiplayer_peer.create_client(steam_id, 0)
	if res == OK:
		print('Connecting peer to host...')
		multiplayer.set_multiplayer_peer(multiplayer_peer)
	else:
		print('Error creating client: %s' % str(res))
		
func _on_lobby_created(connect: int, lobby_id):
	print('CONNECTED status: %s' % str(connect))
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
	print("Adding player to game...")

	if world_instance == null:
		print("Instantiating world...")
		world_instance = world.instantiate()
		get_tree().root.add_child(world_instance)

	# Ensure maze_instance exists before calling spawn_player()
	await get_tree().process_frame  # Wait for scene initialization
	if world_instance.maze_instance == null:
		push_error("ERROR: maze_instance is still NULL in world_instance!")

	var player_to_add = character_scene.instantiate()
	player_to_add.name = str(id)

	if world_instance.has_method("spawn_player"):
		world_instance.spawn_player(player_to_add)
	else:
		push_error("ERROR: spawn_player() not found in world_instance!")



func _del_player(id: int):
	print('Player %s is too cowardly to face the MAZE!' % id)
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()
