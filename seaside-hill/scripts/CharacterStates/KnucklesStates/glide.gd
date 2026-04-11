extends State

@export var fall_state: State
@export var idle_state: State
@export var run_state: State
@export var change_dir_state: State
@export var cannon_state: State
@export var glide_grav: float

func enter() -> void:
	super()
	parent.velocity.y = glide_grav
	
func process_input() -> State:
	if !Input.is_action_pressed("jump"):
		return fall_state
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
	if parent.i_frames.is_stopped():
		parent.velocity.y = glide_grav
		if (parent.velocity.x > 0 and Input.is_action_pressed("move_left")) or (parent.velocity.x < 0 and Input.is_action_pressed("move_right")):
				parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction)
		else:
			parent.velocity.x = move_toward(parent.velocity.x, parent.MAX_SPEED * parent.direction, parent.acc)

	else:
		print(parent.velocity.y)
		parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if parent.velocity.x == 0:
			return idle_state
		else:
			return run_state
	return null
