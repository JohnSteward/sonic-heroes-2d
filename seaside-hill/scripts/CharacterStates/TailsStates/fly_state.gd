extends State

@export var fall_state: State
@export var idle_state: State
@export var run_state: State
@export var action_state: State
@export var cannon_state: State
@export var flight_duration: float
var boost: bool = false

func enter() -> void:
	super()
	parent.start_fly_y = parent.position.y
	parent.hurtbox.set_collision_layer_value(3, true)
	parent.hurtbox.set_collision_layer_value(7, false)
	
func exit() -> void:
	flight_duration = 500
	parent.can_fly = false
#func process_input() -> State:
	#if Input.is_action_just_pressed("jump"):
		#parent.velocity.y = -500
		#boost = true
	#return null
	
func process_input() -> State:
	if Input.is_action_just_pressed("action"):
		return action_state
	return null

func process_frame(delta: float) -> State:
	if parent.velocity.x == 0:
		if Input.is_action_pressed("move_left"):
			parent.direction = -1
		elif Input.is_action_pressed("move_right"):
			parent.direction = 1
	if parent.is_in_cannon:
		return cannon_state
	return null

func process_physics(delta: float) -> State:
	if parent.is_on_floor():
		if abs(parent.velocity.x) > 0:
			return run_state
		return idle_state
	var prev_pos = parent.position.x
	if Input.is_action_pressed("jump") and !boost and parent.can_fly:
		if parent.position.y > parent.start_fly_y - 400:
			parent.velocity.y = -200
		else:
			parent.velocity.y = 0
			boost = false
	else:
		parent.velocity.y += gravity * delta

	if (Input.is_action_pressed("move_left") and parent.velocity.x > 0) or (Input.is_action_pressed("move_right") and parent.velocity.x < 0):
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.stop_speed)
	elif parent.moving:
		print("eyyyyyyy")
		parent.velocity.x = move_toward(parent.velocity.x, parent.MAX_SPEED * parent.direction, parent.acc)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction)

	parent.move_and_slide()
	flight_duration -= abs(parent.position.x - prev_pos)
	if flight_duration <= 0:
		return fall_state
	return null
