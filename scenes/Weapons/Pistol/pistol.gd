extends Node2D

@onready var animations: AnimationPlayer = %AnimationPlayer;
@onready var sprite: Sprite2D = %Sprite2D;
@onready var projectile_exit: Marker2D = %ProjectileExit;
@onready var cooldown_timer: Timer = %CooldownTimer;
@onready var cooldown_progress: ProgressBar = %CooldownProgress;
const GUN_SHOT = preload("res://scenes/Weapons/Pistol/GunShotNoise.tscn");
const BULLET = preload("res://scenes/Weapons/Pistol/Bullet.tscn");

var flip_animation = false;
var on_cooldown = false;

func _ready():
	cooldown_progress.max_value = cooldown_timer.wait_time;

func _physics_process(_delta: float):
	cooldown_progress.value = cooldown_timer.time_left;

func shoot():
	# early return for when weapon is on cooldown
	if on_cooldown:
		return;
	var gunshot = GUN_SHOT.instantiate();
	add_child(gunshot);
		
	cooldown_timer.start();
	on_cooldown = true;
	if !flip_animation:
		animations.play("shoot_right");
		await get_tree().process_frame
		create_projectile();
	else:
		animations.play("shoot_left");
		await get_tree().process_frame
		create_projectile();
	
func flip(direction):
	if direction == 'left':
		flip_animation = true;
		sprite.flip_v = true;
	else:
		flip_animation = false;
		sprite.flip_v = false;
		
func create_projectile():
	var bullet = BULLET.instantiate();
	bullet.global_position = projectile_exit.global_position;
	bullet.rotation = (projectile_exit.global_position - get_parent().get_parent().global_position).angle()
	add_child(bullet);
	
func _on_cooldown_timer_timeout():
	on_cooldown = false;
