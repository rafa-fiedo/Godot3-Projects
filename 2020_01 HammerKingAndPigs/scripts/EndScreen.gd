extends Control

onready var menu_scene = load("res://scenes/Hud/Menu.tscn")

func _on_TextureButton_pressed():
	var er = get_tree().change_scene_to(menu_scene)
	if er != OK:
		print("Failed to start menu scene")