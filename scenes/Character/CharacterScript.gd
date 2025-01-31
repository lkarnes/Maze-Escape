extends CharacterBody2D

var player_speed: int = 150;
@onready var animations: AnimationPlayer = %AnimationPlayer;
var orientation = 'right';

func _physics_process(delta):
	handle_movement();

func handle_movement():
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * player_speed;
	if direction == Vector2.ZERO:
		animations.play('idle');
	elif (direction.x > 0):
		animations.play('run_right');
		orientation = 'right';
	elif (direction.x < 0):
		animations.play('run_left');
		orientation = 'left';
	elif animations.current_animation == 'idle':
		animations.play('run_left');
		orientation = 'left';
	move_and_slide();
