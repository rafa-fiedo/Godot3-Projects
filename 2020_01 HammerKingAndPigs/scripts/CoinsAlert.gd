extends Node2D

var coins_count = 0

func _ready():
	$AnimNum.play(str(coins_count))
