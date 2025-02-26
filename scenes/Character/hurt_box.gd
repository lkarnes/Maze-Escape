extends Area2D

@onready var health_bar = %HealthBar;
@onready var damage_animations = %DamageAnimationPlayer;

func take_damage(damage_points: int):
		health_bar.lose_heart();
		damage_animations.play('lose_heart');
		
