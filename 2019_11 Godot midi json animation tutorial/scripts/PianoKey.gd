extends Node2D

func _ready():
	pass
	
func key_on(duration):
	$AnimatedSprite.animation = "on"
	$Timer.start(duration)

func _on_Timer_timeout():
	$AnimatedSprite.animation = "off"
