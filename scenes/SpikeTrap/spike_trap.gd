extends Area2D

var can_pickup = true;
var trap_armed = false;
var item_type = 'spike_trap';
@onready var sprite: Sprite2D = %Sprite2D;
@onready var animations: AnimationPlayer = %AnimationPlayer;
@onready var trigger_noise: AudioStreamPlayer2D = %TriggerNoise;

func pickup():
	queue_free();
	
func arm_trap() -> void:
	sprite.frame = 1;
	await get_tree().create_timer(1.0).timeout;
	trap_armed = true;

func _on_area_entered(area: Area2D) -> void:
	if 'take_damage' in area and trap_armed:
		animations.play('trigger');
		trigger_noise.pitch_scale = randf_range(0.9, 1.1);
		trigger_noise.play();
		area.take_damage(1);
