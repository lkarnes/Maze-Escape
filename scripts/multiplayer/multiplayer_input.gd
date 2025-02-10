extends MultiplayerSynchronizer

@onready var player = $"../"

var input_direction: Vector2
var username = ''

func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
		
	input_direction = Input.get_vector("left", "right", "up", "down")
