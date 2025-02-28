extends Area2D

@onready var animations: AnimationPlayer = %AnimationPlayer;

func _ready():
	animations.play('idle');

func _on_body_entered(body: Node2D):
	if "add_trophy" in body: 
		body.add_trophy()
		queue_free();
