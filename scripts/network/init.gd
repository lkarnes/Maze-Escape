extends Node

var steam_id: int = 0
var steam_username: String = ""
func _init():
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))

func _ready() -> void:
	Steam.steamInit()
	
	steam_id = Steam.getSteamID()	
	print("SteamID: ", steam_id)
	steam_username = Steam.getPersonaName()
	print("SteamUN: ", steam_username)
	

func _process(_delta: float) -> void:
	Steam.run_callbacks()
