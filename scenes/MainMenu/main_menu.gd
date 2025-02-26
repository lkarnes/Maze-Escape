extends CenterContainer

@export var open_settings_screen = VBoxContainer
@onready var lobby_id = $LobbyID


func _process(delta: float) -> void:
	pass

func _on_host_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/World/World.tscn")


func _on_join_pressed() -> void:
	var id: int = int(lobby_id.text)


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu/Options Menu/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
