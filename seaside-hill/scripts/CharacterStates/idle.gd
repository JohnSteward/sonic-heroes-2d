extends State

@export var run_state: State
@export var jump_state: State
@export var fall_state: State
@export var action_state: State
@export var cannon_state: State
@export var light_dash_state: State


func enter() -> void:
	super()
	parent.hurtbox.set_collision_layer_value(3, true)
	parent.hurtbox.set_collision_layer_value(7, false)
	#parent.hitbox.get_node("hitbox_shape").disabled = true
	parent.can_fly = true
	parent.velocity.x = 0
	parent.speed = 0

func process_frame(delta: float) -> State:
	if parent.is_in_cannon:
		return cannon_state
	return null

func process_input() -> State:
	if parent.light_dash and Input.is_action_just_pressed("action"):
		return light_dash_state
	if Input.is_action_just_pressed("action"):
		return action_state
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		return run_state
	if Input.is_action_just_pressed("swap_left"):
		parent.change_char(parent, -1)
	if Input.is_action_just_pressed("swap_right"):
		parent.change_char(parent, 1)
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	if !parent.is_on_floor():
		return fall_state
	return null
	
