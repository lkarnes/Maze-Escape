extends MultiplayerSynchronizer

var input_direction: Vector2

func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)

	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
func _physics_process(delta: float):
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
func _process(delta):
	pass
