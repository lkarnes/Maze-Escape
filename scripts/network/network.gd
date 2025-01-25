extends Node

const PACKET_READ_LIMIT: int = 32
const LOBBY_NUMBERS_MAX: int = 10

var is_host: bool = false
var lobby_id: int = 0
var lobby_members: Array = []

func create_lobby():
	if lobby_id == 0:
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, LOBBY_NUMBERS_MAX)
