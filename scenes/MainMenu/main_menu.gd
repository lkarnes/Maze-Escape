extends CenterContainer

@export var open_settings_screen = VBoxContainer
@onready var world_scene = preload("res://scenes/World/World.tscn")
var world

func _ready():
	if not world:
		world = world_scene.instantiate()
		
		
func _process(delta: float) -> void:
	pass


func _on_host_pressed() -> void:
	SceneManager.set_scene_as_current(world)
	MultiplayerManager.become_host()


func _on_join_pressed() -> void:
	SceneManager.set_scene_as_current(world)
	MultiplayerManager.join()


func _on_settings_pressed():
	SceneManager.change_scene("res://scenes/MainMenu/Options Menu/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
