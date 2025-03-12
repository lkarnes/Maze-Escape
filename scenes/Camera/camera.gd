class_name Camera extends Camera2D

@export var follow_target: Node2D;

func set_target(target: Node2D):
	follow_target = target;
	
func track_target() -> void:
	if follow_target == null:
		return
	if not is_instance_valid(follow_target):
		return
	global_transform = follow_target.global_transform

func _process(delta: float) -> void:
	track_target()
