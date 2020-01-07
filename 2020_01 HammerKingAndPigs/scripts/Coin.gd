extends Area2D

func _on_Coin_body_entered(body):
	call_deferred("add_coin", body)

func add_coin(body):
	$CollisionShape2D.disabled = true
	$Anim.play("Hit")
	body.add_coins(1)