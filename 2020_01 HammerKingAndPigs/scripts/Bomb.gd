extends KinematicBody2D

export(bool) var fly_left = true

var gravity = 150
var velocity = Vector2(-100,-1)

var is_boom = false
var can_boom = false

func _ready():
	velocity = Vector2(-100, -100) if fly_left else Vector2(0, -1)
	

func boom(): # used after On animation
	$BoomDetector.monitorable = true
	$BoomDetector.monitoring = true
	$Ani.play("Boom")

func turn_off_detector():
	$BoomDetector.monitorable = false
	$BoomDetector.monitoring = false
	collision_mask = 6

func call_die():
	is_boom = true
	call_deferred("boom")

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.y = move_and_slide(velocity, Vector2.UP).y

func _on_StartDetector_body_entered(body):
		if can_boom:
			velocity.x = 0
		
		if !is_boom and can_boom:
			$Ani.play("On")
			is_boom = true

func _on_BoomDetector_body_entered(body):
	body.call_die()


func _on_StartDetecting_timeout():
	can_boom = true
	# $CollisionShape2D.disabled = false
	
	
