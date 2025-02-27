extends CharacterBody2D

var player_speed: int = 150;
enum weapon_types {GUN, BAT}

signal trigger_respawn;

@export var trophies: int = 0;
var items_in_range: Dictionary = {};
var holding_item: bool = false;

@export var selected_weapon: weapon_types = weapon_types.GUN;
@onready var movement_animations: AnimationPlayer = %MovementAnimationPlayer;
@onready var damage_animations: AnimationPlayer = %DamageAnimationPlayer;
@onready var gun_pivot: Marker2D = %GunPivot;
@onready var gun_marker: Marker2D = %GunMarker;
@onready var melee_marker: Marker2D = %MeleeMarker;
@onready var item_holder: Marker2D = %ItemHolder;

const SPIKE_TRAP = preload("res://scenes/SpikeTrap/SpikeTrap.tscn");
const TURRET = preload("res://scenes/Turret/Turret.tscn");

@onready var weapon_obj = {
	"BAT": preload("res://scenes/Weapons/Bat/Bat.tscn"),
	"GUN": preload("res://scenes/Weapons/Pistol/Pistol.tscn")
};
var orientation = 'right';

var meelee_weapon;
var gun;

func _ready():
	var keys = get_action_keys("down")
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
	handle_interact();
	handle_rotate();

func handle_movement():
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	velocity = direction * player_speed;
	var direction_to_mouse = global_position - get_global_mouse_position();
	if direction == Vector2.ZERO:
		if (direction_to_mouse.x < 0):
			movement_animations.play('idle-right');
			orientation = 'right';
		else:
			movement_animations.play('idle-left');
			orientation = 'left';
	elif (direction_to_mouse.x < 0):
		movement_animations.play('run_right');
		orientation = 'right';
	elif (direction_to_mouse.x > 0):
		movement_animations.play('run_left');
		orientation = 'left';
	elif movement_animations.current_animation == 'idle':
		movement_animations.play('run_left');
		orientation = 'left';
		
	
	if meelee_weapon:
		meelee_weapon.set_direction(orientation);
	move_and_slide();

func handle_attacks():
	if melee_marker.get_children().size() > 0:
		meelee_weapon = melee_marker.get_child(0);
	if gun_marker.get_children().size() > 0:
		gun = gun_marker.get_child(0);

	if Input.is_action_just_pressed('attack_move'):
		if meelee_weapon:
			meelee_weapon.swing(orientation);
		if gun:
			gun.shoot();
		
		
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

func _on_health_bar_no_hearts_left() -> void:
	trigger_respawn.emit(self);
	
	
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
	return keys;


func handle_interact():
	if Input.is_action_just_pressed('interact'):
		if holding_item:
			drop_item();
		elif items_in_range.keys().size() > 0:
			print('pick uppables: ', items_in_range);
			var selected_item = items_in_range[items_in_range.keys()[0]];
			print('selected_item: ', selected_item)
			if 'item_type' in selected_item:
				match selected_item.item_type:
					'spike_trap':
						selected_item.pickup();
						pickup_item(selected_item.item_type);
					'turret':
						selected_item.pickup();
						pickup_item(selected_item.item_type);

func _on_interact_zone_area_entered(area: Area2D) -> void:
	if 'can_pickup' in area and area.can_pickup:
		items_in_range[area.name] = area;

func _on_interact_zone_area_exited(area: Area2D) -> void:
	items_in_range.erase(area.name);

func pickup_item(item_type):
	match item_type:
		'spike_trap':
			var trap = SPIKE_TRAP.instantiate();
			melee_marker.visible = false;
			holding_item = true;
			trap.z_index = 0;
			item_holder.add_child(trap);
		'turret':
			var trap = TURRET.instantiate();
			melee_marker.visible = false;
			holding_item = true;
			trap.z_index = 0;
			item_holder.add_child(trap);
			
func drop_item():
	var item = item_holder.get_child(0);
	if 'item_type' in item:
		match item.item_type:
			'spike_trap':
				var trap = SPIKE_TRAP.instantiate();
				trap.can_pickup = false;
				trap.global_position = global_position;
				trap.global_position.y += 5;
				get_parent().add_child(trap);
				trap.arm_trap();
			'turret':
				var trap = TURRET.instantiate();
				trap.can_pickup = false;
				trap.global_position = global_position;
				trap.global_position.y += 5;
				trap.rotation = item.rotation;
				get_parent().add_child(trap);
				trap.arm_trap();
		
		item.queue_free()
		holding_item = false;
	
func handle_rotate():
	var item = item_holder.get_child(0);
	if holding_item && Input.is_action_just_pressed('rotate') && ('can_rotate' in item && item.can_rotate):
		item.rotate(deg_to_rad(90));
		
