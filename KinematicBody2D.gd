extends Area2D

onready var animationSoul = $AnimationPlayer



func _ready():
	floating_animation()
	
func floating_animation():
	animationSoul.play("Float")


func _on_Soul_body_entered(body):
	PlayerStats.souls += 1
	queue_free()
