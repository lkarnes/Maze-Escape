extends MultiplayerSynchronizer

var input_direction: Vector2

func _ready():
	pass

	
func _physics_process(delta: float):
	if is_multiplayer_authority():
		input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
func _process(delta):
	pass
