extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var DASH_SPEED = 125
export var FRICTION = 550

enum {
	MOVE,
	DASH, #maybe?
	ATTACK
}

export var DashCooldown = 1.0
var state = MOVE
var velocity = Vector2.ZERO
var dash_vector = Vector2.DOWN
var stats = PlayerStats


onready var animationPlayer = $AnimationPlayer #animationPlayer.play("Animation ici) pour jouer l'animation
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var spearHitbox = $HitboxPivot/SpearHitbox
onready var hurtbox = $Hurtbox

func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	spearHitbox.knockback_vector = dash_vector
	$Timer.wait_time = DashCooldown

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		DASH:
			dash_state(delta)
			
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		dash_vector = input_vector
		spearHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector) 
		animationTree.set("parameters/Dash/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("dash"):
		if $Timer.time_left <= 0:
			state = DASH
			$Timer.start()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func dash_state(delta):
	velocity = dash_vector * DASH_SPEED
	animationState.travel("Dash")
	move()

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)
	
func dash_animation_finished():
	state = MOVE
	
func attack_animation_finished():
	state = MOVE


func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
