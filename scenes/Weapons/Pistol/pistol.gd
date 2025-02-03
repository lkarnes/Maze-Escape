extends Node2D

@onready var animations:AnimationPlayer = %AnimationPlayer;
@onready var sprite: Sprite2D = %Sprite2D;
@onready var projectile_exit: Marker2D = %ProjectileExit;
@onready var cooldown_timer: Timer = %CooldownTimer;
var flip_animation = false;
var on_cooldown = false;

func shoot():
	# early return for when weapon is on cooldown
	if on_cooldown:
		return;
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
	const BULLET = preload("res://scenes/Weapons/Pistol/Bullet.tscn");
	var bullet = BULLET.instantiate();
	bullet.global_position = projectile_exit.global_position;
	bullet.rotation = (projectile_exit.global_position - get_parent().get_parent().global_position).angle()
	add_child(bullet);
	
func _on_cooldown_timer_timeout():
	print('cooldown over');
	on_cooldown = false;
