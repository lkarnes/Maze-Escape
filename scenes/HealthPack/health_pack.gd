extends Area2D

@onready var animations: AnimationPlayer = %AnimationPlayer;

func _ready() -> void:
	animations.play('idle');

func _on_body_entered(body: Node2D):
	if "add_health" in body: 
		body.add_health();
		queue_free();
