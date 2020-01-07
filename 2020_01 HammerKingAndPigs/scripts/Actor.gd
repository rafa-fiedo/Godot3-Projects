extends KinematicBody2D
class_name Actor

var run_speed = 150
var jump_speed = -400
var gravity = 1500

var velocity = Vector2()

enum {MOVING, STOP}

var state = MOVING

func _ready():
	pass

func _physics_process(delta):
	velocity.y += gravity * delta
	movement()
	attack()
	velocity = move_and_slide(velocity, Vector2(0, -1))

func movement():
	velocity.x = 0
	if state != MOVING:
		return	

	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_jump')
	
	var anim_name = "Idle"
			
	if right:
		velocity.x += run_speed
		flip(false)
		anim_name = "Run"
	elif left:
		velocity.x -= run_speed
		flip(true)
		anim_name = "Run"
	else:
		velocity.x = 0
		anim_name = "Idle"

	if is_on_floor() and jump:
		velocity.y = jump_speed
	
	if !is_on_floor():
		anim_name = "Jump"
	
	anim_play(anim_name)

func walk_in(door):
	state = STOP
	anim_play("DoorIn")
	door.open_ani()
	# yield(get_tree().create_timer(1),"timeout")
	yield(get_node("ani"), "animation_finished")
	door.next_level()

func attack():
	if state == STOP:
		return
		
	if Input.is_action_just_pressed('ui_attack'):
		anim_play("Attack")
	
func flip(is_flipped):
	$Sprite.flip_h = is_flipped
	$CollisionShape2D.position.x = 8 if is_flipped else -8
	
	
func anim_play(new_animation):
	match $ani.current_animation:
		"Attack":
			if(new_animation == "Dead"):
				$ani.play(new_animation)
			return
		new_animation: # don't reuse animation if already played
			pass
		_:
			$ani.play(new_animation)

func _on_ani_animation_finished(anim_name):
	match anim_name:
		"DoorOut":
			state = MOVING
