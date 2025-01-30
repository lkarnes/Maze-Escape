extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$"VBoxContainer/StartGame".grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://scenes/World/World.tscn")


func _on_options_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
