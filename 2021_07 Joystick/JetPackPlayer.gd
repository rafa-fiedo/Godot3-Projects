extends KinematicBody2D

var speed = 128

func _on_MobileJoystick_use_move_vector(move_vector):
	move_and_slide(move_vector * speed)
	
	$Sprite.flip_h = move_vector.x < 0
