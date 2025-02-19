class_name HotKeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name : String = "move_left"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	load_keybinds()



func load_keybinds() -> void:
	rebind_action_key(SettingsContainer.get_keybind(action_name))


func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"move_left":
			label.text = "Move Left"
		"move_right" :
			label.text = "Move Right"
		"move_up" :
			label.text = "Move Up"
		"move_down" :
			label.text = "Move Down"
		"attack_move" :
			label.text = "Attack"

# Change buttons text
func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	
	if action_events.size() > 0:
		var action_event = action_events[0]
		
		# Check if the event is a keyboard event
		if action_event is InputEventKey:
			var action_keycode = get_action_keys(action_name)
			button.text = str(action_keycode[0])
		else:
				button.text = "Mouse/Other"
	else:
		button.text = "No key assigned"

func get_action_keys(action_name: String) -> Array:
	var keys = []
	if InputMap.has_action(action_name):
		for event in InputMap.action_get_events(action_name):
			if event is InputEventKey:
				keys.append(OS.get_keycode_string(event.physical_keycode)) # Use physical_keycode
			elif event is InputEventJoypadButton:
				keys.append("Joystick Button " + str(event.button_index))
			elif event is InputEventMouseButton:
				keys.append("Mouse Button " + str(event.button_index))
	return keys


func _on_button_toggled(button_pressed):
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_key_input(button_pressed)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
			
		
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_text_for_key()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false


func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	SettingsContainer.set_keybind(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
