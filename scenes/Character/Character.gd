extends CharacterBody2D

var player_speed: int = 200;
@onready var animations: AnimationPlayer = %AnimationPlayer;

func _ready():
	var maze = Maze.generate_maze(20,20);
	
	for row in maze:
		print(row);
	

func _physics_process(delta):
	handle_movement();

func handle_movement():
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * player_speed;
	if direction == Vector2.ZERO:
		animations.play('idle');
	elif (direction.x > 0):
		animations.play('run_right');
	elif (direction.x < 0):
		animations.play('run_left');
	elif animations.current_animation == 'idle':
		animations.play('run_left');
	move_and_slide();
