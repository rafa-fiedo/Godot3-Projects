extends KinematicBody2D
export(bool) var walk_in_animation = true
export(bool) var use_camera = false

enum {MOVING, STOP}

var speed = Vector2(150, 400)
var gravity = 1500
var velocity = Vector2()
var state = STOP

var coins = 0

func _ready():
	if !walk_in_animation:
		state = MOVING
		$ani.play("Idle")
	
	if use_camera:
		$Camera2D.current = true
	
	
func _on_SwordArea_body_entered(body):
	body.call_die()
	pass # Replace with function body.

func _physics_process(delta):
	var is_jump_interrupted = Input.is_action_just_released("game_jump") and velocity.y < 0.0
	var direction = get_direction()
	
	if direction.y == -1:
		$Jump.play()
	
	calculate_move_velocity(direction, is_jump_interrupted)
	velocity = move_and_slide(velocity, Vector2.UP)
	set_animation()
	set_flip()
	attack()


func add_coins(amount):
	coins += amount

func set_flip():
	if velocity.x == 0:
		return
	var is_flipped = true if velocity.x < 0 else false
	$Sprite.flip_h = is_flipped
	$CollisionShape2D.position.x = 8 if is_flipped else -8
	$SwordArea/CollisionShape2D.position.x = -10 if is_flipped else 11

func set_animation():
	if state == STOP:
		return
		
	var anim_name = "Idle"
	if velocity.x != 0:
		anim_name = "Run"
	if !is_on_floor():
		anim_name = "Jump"
		
	anim_play(anim_name)

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

func call_die():
	call_deferred("die")
	
func die():
	$".".collision_layer = 0
	state = STOP
	anim_play("Dead")
	yield(get_node("ani"), "animation_finished")
	get_tree().reload_current_scene()
	
	Global.music_playback_time = 0

func calculate_move_velocity(direction, is_jump_interrupted):
	var new_velo = velocity
	new_velo.x = speed.x * direction.x
	new_velo.y += gravity * get_physics_process_delta_time()
	if direction.y == -1:
		new_velo.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velo.y = 0.0
	
	velocity = new_velo
	
func calculate_stomp_velocity(impulse):
	if state == STOP:
		return
	velocity.y = -impulse 

func get_direction():
	if state == STOP:
		return Vector2.ZERO
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-1.0 if Input.is_action_just_pressed("game_jump") and is_on_floor() else 0.0
	)


func walk_in(door):
	state = STOP
	anim_play("DoorIn")
	door.open_ani()
	yield(get_node("ani"), "animation_finished")
	door.next_level()

func attack():
	if state == STOP:
		return
		
	if Input.is_action_just_pressed('game_attack'):
		anim_play("Attack")
		$SwordArea.monitorable = true
		$SwordArea.monitoring = true


func _on_ani_animation_finished(anim_name):
	match anim_name:
		"DoorOut":
			state = MOVING
		"Attack":
			$SwordArea.monitorable = false
			$SwordArea.monitoring = false



