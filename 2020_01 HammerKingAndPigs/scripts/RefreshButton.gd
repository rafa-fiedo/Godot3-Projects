extends Control

func _on_TextureButton_pressed():
	Global.music_playback_time = 0
	get_tree().reload_current_scene()

func _process(delta):
	if Input.is_action_just_pressed("game_reset_level"):
		Global.music_playback_time = 0
		get_tree().reload_current_scene()