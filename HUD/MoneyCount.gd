extends Control

onready var souls = $SoulsCount

func _process(delta):
	souls.text = str(PlayerStats.souls).pad_zeros(3)
