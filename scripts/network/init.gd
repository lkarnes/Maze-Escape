extends Node

var steam_id: int = 0
var steam_username: String = ""
func _init():
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))

func _ready() -> void:
	var INIT: Dictionary = Steam.steamInitEx( true, 480 )
	print("Did Steam initialize?: %s " % INIT)
	if INIT['status'] != 1:
		print('Failed to initialize Steam. ' + str(INIT['verbal']) + ' Shutting down...')

	steam_id = Steam.getSteamID()
	print("ID: ", steam_id)
	steam_username = Steam.getPersonaName()
	print("username: ", steam_username)


func _process(_delta: float) -> void:
	Steam.run_callbacks()
