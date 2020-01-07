extends KinematicBody2D
class_name PigActor

export(bool) var flip_on_start = false
export(bool) var disable_move = false
export(bool) var run_right = false
export(bool) var body_free = false
export(PackedScene) var coin_scene = null

export(int) var basic_speed = -185

enum {STOP, MOVING, DEAD}

var velocity = Vector2()

var gravity = 1000
var state = MOVING

func _ready():
	velocity = Vector2(basic_speed, 0)
	if run_right:
		velocity = Vector2(-velocity.x, velocity.y)
	if disable_move:
		state = STOP

func _on_StompDetector_body_entered(body):
	# I don't using this global position y because move_slide is changing y depending on speed process.
	# It's small value, but when enemy is faster then will be problem
	# y positions from collision box makes sure that player will be above
	
#	print("body y " + str(body.global_position.y))
#	print("body velocity" + str(body.velocity))
#	print("stomp y " + str(stomp_y))
#	print("pig y " + str(global_position.y))
	
	var stomp_y = $StompDetector/CollisionShape2D.global_position.y + $StompDetector/CollisionShape2D.shape.extents.y
	if body.global_position.y < stomp_y:
		body.calculate_stomp_velocity(300)
		call_die()

func _on_PlayerDetector_body_entered(body):
	$ani.play("Attack")
	if body.global_position.x > global_position.x:
		flip(true)
	else:
		flip(false)
	
	state = STOP
	body.die()

func _physics_process(delta):
	if state == STOP:
		return
	if state == DEAD:
		velocity.x = 0

	velocity.y += gravity * delta
	if is_on_wall():
		velocity.x *= -1
	velocity.y = move_and_slide(velocity, Vector2.UP).y
	
	if state != MOVING:
		return
	set_animation()
	set_flip()

func call_die():
	"it can be used in outside class, for example human killing enemy"
	if state == DEAD:
		return

	call_deferred("die")

func run():
	state = MOVING
	
func check_body_free():
	if body_free:
		queue_free()

func die():
	if coin_scene != null:
		var coin_instance = coin_scene.instance()
		coin_instance.position = Vector2(5,-8)
		add_child(coin_instance)
	
	$StompDetector/CollisionShape2D.disabled = true
	$StompDetector.monitoring = false
	$StompDetector.monitorable = false
	$PlayerDetector/CollisionShape2D.disabled = true
	$PlayerDetector.monitoring = false
	$PlayerDetector.monitorable = false
	$".".collision_layer = 0
	state = DEAD
	$ani.play("Dead")
	$Color.play("Normal")

func set_animation():
	if state != MOVING:
		return

	var anim_name = "Idle"
	if velocity.x != 0:
		anim_name = "Run"
	if !is_on_floor():
		anim_name = "Jump"

	anim_play(anim_name)

func set_flip():
	if velocity.x == 0:
		return
	var is_flipped = true if velocity.x > 0 else false
	
	flip(is_flipped)

	
func flip(is_flipped):
	$Sprite.flip_h = is_flipped
	$CollisionShape2D.position.x = -1 if is_flipped else 5
	$StompDetector/CollisionShape2D.position.x = -1 if is_flipped else 5
	$PlayerDetector/CollisionShape2D.position.x = -1 if is_flipped else 5

func attack():
	pass


func anim_play(new_animation):
	match $ani.current_animation:
		"Attack":
			return
		new_animation: # don't reuse animation if already played
			pass
		_:
			$ani.play(new_animation)


