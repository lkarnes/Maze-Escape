extends Area2D

@export var damage = 20;
@onready var animations: AnimationPlayer = %AnimationPlayer;

func swing(direction):
	animations.animation_set_next('swing_' + direction, 'idle_' + direction);

func set_direction(direction):
	if animations.current_animation != 'idle_' + direction: 
		animations.play('idle_' + direction);
