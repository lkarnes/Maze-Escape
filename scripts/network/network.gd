extends Node

const PACKET_READ_LIMIT: int = 32
const LOBBY_NUMBERS_MAX: int = 10

var is_host: bool = false
var lobby_id: int = 0
var lobby_members: Array = []
var peer: MultiplayerPeer

func _ready():
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.p2p_session_request.connect(_on_p2p_session_request)


func _process(delta):
	if lobby_id > 0:
		read_all_p2p_packets()


func create_lobby():
	if lobby_id == 0:
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, LOBBY_NUMBERS_MAX)


func _on_lobby_created(connect: int, this_lobby_id: int):
	if connect == 1:
		lobby_id = this_lobby_id

	Steam.setLobbyJoinable(lobby_id, true)
	
	Steam.setLobbyData(lobby_id, "name", "MazeEscapeLobby")
	
	print('CREATED LOBBY: ', lobby_id)
	var set_relay: bool = Steam.allowP2PPacketRelay(true)
	
	peer = SteamMultiplayerPeer.new()
	peer.create_host(0)
	
	
func join_lobby(this_lobby_id: int):
	Steam.joinLobby(this_lobby_id)
	
	
func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int):
	print('JOINING LOBBY')
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		lobby_id = this_lobby_id
		
		get_lobby_members()
		make_p2p_handshake()
		
		var lobbyOwnerId := Steam.getLobbyOwner(this_lobby_id)
		multiplayer.multiplayer_peer = peer
		peer.create_client(lobbyOwnerId, 0)
		
		
func get_lobby_members():
	print('GETTING LOBBY MEMBERS!')
	lobby_members.clear()
	
	var num_of_lobby_members: int = Steam.getNumLobbyMembers(lobby_id)
	for member in range(0, num_of_lobby_members):
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id, member)
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		print('MEMBER: ', member_steam_name)
		
		lobby_members.append({"steam_id": member_steam_id, "steam_name": member_steam_name})
		
		
func send_p2p_packet(this_target: int, packet_data: Dictionary, send_type: int = 0):
	var channel: int = 0
	var this_data: PackedByteArray
	this_data.append_array(var_to_bytes(packet_data))
	print('TARGET: ', this_target)
	if this_target == 0:
		print('LOBBY MEMBERS: ', lobby_members)
		if lobby_members.size() > 1:
			for member in lobby_members:
				if member["steam_id"] != NetworkSetup.steam_id:
					print('Sending packet to: ', member)
					Steam.sendP2PPacket(member["steam_id"], this_data, send_type, channel)
	else:
		Steam.sendP2PPacket(this_target, this_data, send_type, channel)


func make_p2p_handshake():
	print('ATTEMPTING HANDSHAKE...')
	send_p2p_packet(0, {"message": "handshake", "steam_id": NetworkSetup.steam_id, "username": NetworkSetup.steam_username})
	print('FINISHED HANDSHAKE!')
			


func _on_p2p_session_request(remote_id: int):
	var this_requestor: String = Steam.getFriendPersonaName(remote_id)
	print('REQUESTOR: ', this_requestor)
	
	Steam.acceptP2PSessionWithUser(remote_id)


func read_all_p2p_packets(read_count: int = 0):
	if read_count > PACKET_READ_LIMIT:
		return
	
	if Steam.getAvailableP2PPacketSize(0) > 0:
		read_p2p_packet()
		read_all_p2p_packets(read_count + 1)
			
		
func read_p2p_packet():
	var packet_size: int = Steam.getAvailableP2PPacketSize(0)
	
	if packet_size > 0:
		var this_packet: Dictionary = Steam.readP2PPacket(packet_size, 0)
		var packet_sender: int = this_packet["remote_steam_id"]
		var packet_code: PackedByteArray = this_packet["data"]
		var readable_data: Dictionary = bytes_to_var(packet_code)
		print('READING PACKET: ', readable_data)
		
		if readable_data.has("message"):
			match readable_data["message"]:
				"handshake":
					print("PLAYER: ", readable_data["username"], " HAS JOINED!!!")
					get_lobby_members()
					
