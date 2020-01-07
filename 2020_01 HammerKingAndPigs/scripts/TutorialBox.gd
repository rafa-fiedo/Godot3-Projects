extends Control
export(String) var text_tutorial = "Sample tutorial text"
export(bool) var autorun = true

func _ready():
	$NinePatchRect/CenterContainer/TutorialText.text = text_tutorial
	
	if autorun:
		$AnimationPlayer.play("Appear")
	else:
		visible = false
		

func _on_Timer_timeout():
	$AnimationPlayer.play("Disappear")


func run():
	$AnimationPlayer.play("Appear")
	$Timer.start()
	# visible = true

func turn_on_visible():
	visible = true
	
