extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if "trophies" in body: 
		body.trophies += 1;
		print(body.trophies);
		queue_free();
