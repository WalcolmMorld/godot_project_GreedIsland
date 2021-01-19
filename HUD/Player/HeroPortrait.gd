extends Node2D


onready var animationPortrait = $AnimationPlayer
onready var healtCheck = $PlayerStats

func _ready():
	blinking_animation()
		

func blinking_animation():
	animationPortrait.play("Blinking")

func porHurt_animation_started():
	print ("aouch")
	animationPortrait.play("Hurt")

func porHurt_animation_finished():
	blinking_animation()


