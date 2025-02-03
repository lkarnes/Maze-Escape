extends Area2D

@export var damage = 20;
@onready var animations: AnimationPlayer = %AnimationPlayer;

func swing(direction):
	animations.play('swing_' + direction);

func set_direction(direction):
	if animations.current_animation != 'idle_' + direction and animations.current_animation != 'swing_' + direction: 
		animations.play('idle_' + direction);
