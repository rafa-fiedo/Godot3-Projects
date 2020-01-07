extends Node

export(bool) var move_pig_on_move = false
export(bool) var ninja_alert = false
var bool_pig_run_used = false

var hidden_passage_checkout = false

func _ready():
	Global.set_playback_time_music($Music)
	
func _on_hidden_pasage_body_entered(body):
	hidden_passage_checkout = true
	
func _process(delta):
	
	if move_pig_on_move:
		if !bool_pig_run_used:
			if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
				$Pig.run()
				bool_pig_run_used = true
	
	
	if ninja_alert:
		if !hidden_passage_checkout:
			if $PigWithBomb.state == $PigWithBomb.DEAD and $PigWithBomb2.state == $PigWithBomb2.DEAD:
				$wow_ninja.run()
				ninja_alert = false
		


