extends PigActor

export(bool) var super_fast = false
onready var bomb_scene = load("res://scenes/Bomb.tscn")

func _ready():
	$AttackTime.wait_time = rand_range(0.1,0.2)
	$AttackTime.start()
	
	if super_fast:
		$Color.play("Fast")
	else:
		$Color.play("Normal")

func set_flip():
	if velocity.x == 0:
		return
	var is_flipped = true if velocity.x > 0 else false
	
	$Sprite.flip_h = is_flipped
	$CollisionShape2D.position.x = -1 if is_flipped else 1
	$StompDetector/CollisionShape2D.position.x = -1 if is_flipped else 1

func animation_after_attack():
	$ani.play("Idle")
	var bomb = bomb_scene.instance()
	bomb.position = $BombStart.position
	add_child(bomb)

func _on_Timer_timeout():
	$AttackTime.wait_time = rand_range(0.1,1) if super_fast else rand_range(1,3)
	if state == DEAD:
		return
	$ani.play("Throw")
