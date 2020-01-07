extends PigActor

func call_jump():
	velocity.y -= 150

func call_run():
	if state == DEAD:
		return
	state = MOVING