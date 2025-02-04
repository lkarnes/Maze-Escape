extends CharacterBody2D

var player_speed: int = 150;
enum weapon_types {GUN, BAT}
@export var selected_weapon: weapon_types = weapon_types.GUN;
@onready var animations: AnimationPlayer = %AnimationPlayer;
@onready var gun_pivot: Marker2D = %GunPivot;
@onready var gun_marker: Marker2D = %GunMarker;
@onready var melee_marker: Marker2D = %MeleeMarker;
@onready var weapon_obj = {
	"BAT": preload("res://scenes/Weapons/Bat/Bat.tscn"),
	"GUN": preload("res://scenes/Weapons/Pistol/Pistol.tscn")
};
var orientation = 'right';

func _ready():
	match selected_weapon:
		weapon_types.GUN:
			var gun = weapon_obj["GUN"].instantiate();
			gun_marker.add_child(gun);
		weapon_types.BAT:
			var bat = weapon_obj["BAT"].instantiate();
			melee_marker.add_child(bat);

func _physics_process(_delta):
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
	var meelee_weapon;
	var gun;
	if melee_marker.get_children().size() > 0:
		meelee_weapon = melee_marker.get_child(0);
	if gun_marker.get_children().size() > 0:
		gun = gun_marker.get_child(0);

	if Input.is_action_just_pressed('attack'):
		if meelee_weapon:
			meelee_weapon.swing(orientation);
		if gun:
			gun.shoot();
	else:
		if meelee_weapon:
			meelee_weapon.set_direction(orientation);
		
		
func update_gun_pivot_rotation():
	var gun;
	if gun_marker.get_children().size() > 0:
		gun = gun_marker.get_child(0);
		var current_mouse_position = get_global_mouse_position();
		gun_pivot.rotation = get_angle_to(current_mouse_position);
		var local_position = current_mouse_position - global_position;
		if local_position.x < 0:
			gun.flip('left');
		else:
			gun.flip('right');
	
