extends Area2D

@export var damage = 20;
@onready var animations: AnimationPlayer = %AnimationPlayer;

func swing(direction):
	var aim_direction = get_global_mouse_position() - global_position
	var aim_rotation = atan2(aim_direction.y, aim_direction.x)
	if direction == 'left': 
		aim_rotation = atan2(-aim_direction.y, -aim_direction.x);

	# Set rotation of parent node (usually player or weapon)
	get_parent().rotation = aim_rotation

	# Play swing animation (assuming "swing_right" is a valid animation)
	animations.play('swing_' + direction)
	

func set_direction(direction):
	if animations.current_animation != 'idle_' + direction and animations.current_animation != 'swing_' + direction: 
		animations.play('idle_' + direction);


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with('swing'):
		get_parent().rotation = 0;
