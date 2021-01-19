extends TextureButton


export var DashCooldown = 1.0


func _ready():
	$Timer.wait_time = DashCooldown
	$Sweep.texture_progress = texture_normal
	$Sweep.value = 0
	set_process(false)

func _process(delta):
	$Sweep.value = int(($Timer.time_left / DashCooldown) * 100)
	
func _physics_process(delta):
	if Input.is_action_just_pressed("dash"):
		if $Timer.time_left <= 0:
			disabled = true
			set_process(true)
			$Timer.start()
	
func _on_Timer_timeout():
	print("ability ready")
	$Sweep.value = 0
	disabled = false
	set_process(false)
