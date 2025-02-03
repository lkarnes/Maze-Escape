extends CharacterBody2D

var player_speed: int = 150;
@onready var animations: AnimationPlayer = %AnimationPlayer;
@onready var gun_pivot: Marker2D = %GunPivot;
var orientation = 'right';

func _physics_process(delta):
	handle_movement();
	handle_attacks();
	update_gun_pivot_rotation();

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
	
func handle_attacks():
	var meelee_weapon = %MeleeMarker.get_child(0);
	var gun = %GunMarker.get_child(0);

	if Input.is_action_just_pressed('attack'):
		if meelee_weapon:
			meelee_weapon.swing(orientation);
		if gun:
			gun.shoot();
	else:
		if meelee_weapon:
			meelee_weapon.set_direction(orientation);
		
		
func update_gun_pivot_rotation():
	var gun = %GunMarker.get_child(0);
	if gun:
		var current_mouse_position = get_global_mouse_position();
		gun_pivot.rotation = get_angle_to(current_mouse_position);
		var local_position = current_mouse_position - global_position;
		if local_position.x < 0:
			gun.flip('left');
		else:
			gun.flip('right');
	
