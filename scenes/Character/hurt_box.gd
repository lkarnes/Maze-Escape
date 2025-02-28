extends Area2D

@onready var health_bar = %HealthBar;
@onready var damage_animations = %DamageAnimationPlayer;
@onready var hurt_audio: AudioStreamPlayer2D = %HurtAudio;

func take_damage(damage_points: int):
		health_bar.lose_heart();
		damage_animations.play('lose_heart');
		hurt_audio.play();
		
