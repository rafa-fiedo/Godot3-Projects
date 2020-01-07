extends "res://scripts/Level.gd"

func _on_MusicStart_timeout():
	$Music.play()

func _on_Coin_body_entered(body):
	$pigs_attack2/pigs.visible = true
	$pigs_attack2/Decoration2.queue_free()
	for pig in $pigs_attack2/pigs.get_children():
		pig.call_run()
	
func _on_StopPigsDoor_1_body_entered(body):
	$PigDoor.stop_spawn()
	$PigDoor2.stop_spawn()


func _on_PlayerDetection_body_entered(body):
	for pig in $pigs_attack/pigs.get_children():
		pig.call_run()



