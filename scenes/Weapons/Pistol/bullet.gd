extends Area2D

func _physics_process(delta):
	const SPEED = 600;
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta;

func _on_body_entered(body):
	queue_free();
	if body.has_method("take_damage"):
		body.take_damage()
