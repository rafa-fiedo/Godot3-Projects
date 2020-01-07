extends Area2D
export(PackedScene) var target_stage
export(bool) var closing_animation = false
export(int) var coins_needed = 0
export(float) var monster_start = 1.5

export(PackedScene) var coins_alert
export(PackedScene) var enemy_spawn

var player_body = null

func _ready():
	player_body = null # to be sure
	# this only tmp objects which help set transformations
	$CoinsAlertTMP.queue_free()
	
	if closing_animation:
		$ani.play("close")
		
	if enemy_spawn != null:
		$MonsterSpawnStart.start(monster_start)

func _on_MonsterSpawn_timeout():
	$ani.play("open")
	
func _on_MonsterRate_timeout():
	var enemy_ins = enemy_spawn.instance()
	enemy_ins.run_right = true
	enemy_ins.body_free = true
	enemy_ins.position.y = 28
	enemy_ins.velocity = Vector2(-180, 0)
	add_child(enemy_ins)
	
func start_monster_spawn():
	if enemy_spawn == null:
		return
		
	$MonsterRate.start()

func _on_Door_body_entered(body):
	player_body = body

func _on_Door_body_exited(body):
	player_body = null

func _process(delta):

	if Input.is_action_just_pressed('game_use'):
		if !target_stage:
			return
		
		if player_body:
			if player_body.coins < coins_needed:
				show_coins_alert((coins_needed - player_body.coins))
				return
			player_body.walk_in(get_node("."))

func open_ani():
	$ani.play("open")
	
func stop_spawn():
	$MonsterRate.stop()
	$MonsterSpawnStart.stop()

func next_level():
	if !target_stage:
		return
	
	#Global.music_playback_time = get_tree().current_scene.Music.get_playback_position()
	Global.save_playback_time_using_scene(get_tree().current_scene)
	
	var er = get_tree().change_scene_to(target_stage)
	if er != OK:
		print("Failed to change scene using Door")

func show_coins_alert(coins):
	var coins_alert_ins = coins_alert.instance()
	coins_alert_ins.coins_count = coins
	coins_alert_ins.position = Vector2(5, -35)
	coins_alert_ins.scale = Vector2(1.5, 1.5)
	
	add_child(coins_alert_ins)

