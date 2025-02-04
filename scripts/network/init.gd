extends Node

var steam_id: int = 0
var steam_username: String = ""
var peer: MultiplayerPeer
func _init():
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))

func _ready() -> void:
	var INIT: Dictionary = Steam.steamInitEx( true, 480 )
	print("Did Steam initialize?: %s " % INIT)
	if INIT['status'] != 0:
		print('Failed to initialize Steam. ' + str(INIT['verbal']) + ' Shutting down...')

	steam_id = Steam.getSteamID()
	print("ID: ", steam_id)
	steam_username = Steam.getPersonaName()
	print("username: ", steam_username)
	
	peer = SteamMultiplayerPeer.new()
	peer.create_host(0)
	multiplayer.multiplayer_peer = peer


func _process(_delta: float) -> void:
	Steam.run_callbacks()
