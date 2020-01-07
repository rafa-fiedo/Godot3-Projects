extends Area2D



func _on_EnemyJump_body_entered(body):
	body.call_jump()
