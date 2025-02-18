class_name OptionsMenu

extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button as Button


signal exit_options_menu


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu/main_menu.tscn")
	SettingsSignalBus.emit_set_settings_dictionary(SettingsContainer.create_storage_dictionary())
