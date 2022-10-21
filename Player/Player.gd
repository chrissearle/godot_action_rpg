extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

var velocity = Vector2.ZERO

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")

func roll_state(delta):
	pass

func move_state(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		
		animation_state.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")

		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_animation_finished():
	state = MOVE
