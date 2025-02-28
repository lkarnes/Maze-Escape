extends Area2D

const GUN_SHOT = preload("res://scenes/Weapons/Pistol/GunShotNoise.tscn");

var can_pickup = true;
var trap_armed = false;
var item_type = 'turret';
var on_cooldown = false;
var can_rotate = true;
var target;

@onready var turret_head: Sprite2D = %TurretHeadSprite;
@onready var laser: Line2D = %Laser;
@onready var rotation_animations = %RotationAnimationPlayer;
@onready var shoot_animations = %ShootAnimationPlayer;
@onready var raycast: RayCast2D = $TurretHeadSprite/RayCast2D;
@onready var cooldown_timer: Timer = %CooldownTimer;
@onready var bullet_exit = %BulletExit;

const BULLET = preload("res://scenes/Weapons/Pistol/Bullet.tscn");

var max_laser_length = 500  # Maximum laser range

func _process(delta):
	if trap_armed:
		raycast.force_raycast_update()  # Update raycast collision
		var end_position: Vector2 = Vector2(max_laser_length, 0)
		if target and 'global_position' in target:
			var angle_to_target = rad_to_deg(get_angle_to(target.global_position));
			var collider = raycast.get_collider();
			if (raycast.is_colliding() and "take_damage" not in collider) or (angle_to_target > 30 or angle_to_target < -30):
				target = null;
				rotation_animations.play('scan');
			else:
				turret_head.rotation = get_angle_to(target.global_position);
		elif !rotation_animations.is_playing():
			rotation_animations.play('scan');

		# Check for collision
		if raycast.is_colliding():
			end_position = to_local(raycast.get_collision_point())  # Stop at collision point
			var collider = raycast.get_collider()  # Get the object that the raycast hit
			if "take_damage" in collider && !on_cooldown:
				target = collider;
				on_cooldown = true;
				await get_tree().create_timer(0.1).timeout;
				shoot();
				cooldown_timer.start();
				
		# Update laser visuals
		laser.clear_points()
		laser.add_point(Vector2.ZERO)
		end_position.y = 0;
		end_position.x += 10;
		laser.add_point(end_position)

func _ready() -> void:
	laser.visible = false;

func pickup():
	queue_free();

func arm_trap() -> void:
	await get_tree().create_timer(1.0).timeout;
	trap_armed = true;
	laser.visible = true;
	rotation_animations.play('scan');
	
func shoot():
	var gunshot = GUN_SHOT.instantiate();
	add_child(gunshot);
	rotation_animations.pause();
	create_projectile();
	shoot_animations.play('shoot');
	await get_tree().create_timer(0.3).timeout;
	
func create_projectile():
	var bullet = BULLET.instantiate();
	bullet.global_position = bullet_exit.global_position;
	bullet.rotation = (bullet_exit.global_position - global_position).angle()
	add_child(bullet);
	
func _on_timer_timeout() -> void:
	on_cooldown = false;
