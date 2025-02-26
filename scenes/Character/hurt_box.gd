extends Area2D

@onready var health_bar = %HealthBar;

func take_damage(damage_points: int):
		health_bar.lose_heart();
