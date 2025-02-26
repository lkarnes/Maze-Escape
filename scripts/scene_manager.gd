extends Node

func change_scene(scene_path: String):
	var scene_resource = ResourceLoader.load(scene_path) as PackedScene
	if scene_resource:
		var new_scene = scene_resource.instantiate()
		var root = get_tree().root
		var current_scene = get_tree().current_scene
		current_scene.queue_free()
		root.add_child(new_scene)
		get_tree().current_scene = new_scene


func set_scene_as_current(scene_obj):
	var root = get_tree().root
	var current_scene = get_tree().current_scene
	current_scene.queue_free()
	root.add_child(scene_obj)
	get_tree().current_scene = scene_obj
	
