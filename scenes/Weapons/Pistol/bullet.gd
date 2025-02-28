extends Area2D

func _physics_process(delta):
	const SPEED = 600;
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta;

func _on_area_entered(area: Area2D) -> void:
	print(area);
	queue_free();
	if area.has_method("take_damage"):
		area.take_damage(1)
