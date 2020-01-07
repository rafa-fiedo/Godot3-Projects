extends Area2D

func _on_Spikes_body_entered(body):
	body.call_die()
