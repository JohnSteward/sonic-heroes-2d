extends State

@export var run_state: State
@export var jump_state: State
@export var fall_state: State
@export var action_state: State


func enter() -> void:
	super()
	parent.hurtbox.get_node("CollisionShape2D").disabled = false
	parent.can_fly = true
	parent.velocity.x = 0
	parent.speed = 0

func process_input() -> State:
	if Input.is_action_just_pressed("action"):
		return action_state
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		return run_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	if !parent.is_on_floor():
		return fall_state
	return null
	
