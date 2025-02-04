extends AudioStreamPlayer2D

func _ready():
	pitch_scale = randf_range(0.9, 1.1);
	play();

func _on_finished():
	queue_free();
