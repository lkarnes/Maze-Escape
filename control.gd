extends CenterContainer


@onready var host = $PanelContainer/MenuContainer/Host as Button
@onready var quit = $PanelContainer/MenuContainer/Quit as Button
@onready var settings = $PanelContainer/MenuContainer/Settings as Button
@onready var options_menu = $OptionsMenu as OptionsMenu
@onready var panel_container = $PanelContainer as PanelContainer

@onready var start_level = preload("res://scenes/World/World.tscn") as PackedScene


func _ready():
	handle_connecting_signals()


func on_host_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_quit_pressed() -> void:
	get_tree().quit()

func on_settings_pressed() -> void:
	panel_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


func on_exit_options_menu() -> void:
	pass

func handle_connecting_signals() -> void:
	host.button_down.connect(on_host_pressed)
	settings.button_down.connect(on_settings_pressed)
	quit.button_down.connect(on_quit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
