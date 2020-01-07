extends Control

export(PackedScene) var start_scene

func _process(delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		var er = get_tree().change_scene_to(start_scene)
		if er != OK:
			print("Failed to start first level")

func _on_StartButton_pressed():
	var er = get_tree().change_scene_to(start_scene)
	if er != OK:
		print("Failed to start first level")
