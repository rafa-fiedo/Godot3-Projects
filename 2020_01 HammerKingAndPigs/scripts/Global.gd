extends Node

var music_playback_time = 0
var music_name = ""
var music_volume_db = 0

func _ready():
	pass

func _process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func set_playback_time_music(music):
	if music.stream.resource_path == music_name:
		music.volume_db = music_volume_db
		music.play(music_playback_time)

func save_playback_time_using_scene(scene):
	for child in get_tree().current_scene.get_children():
		if child.name == "Music":
			music_playback_time = child.get_playback_position()
			music_name = child.stream.resource_path
			music_volume_db = child.volume_db