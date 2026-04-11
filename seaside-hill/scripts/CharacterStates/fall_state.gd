extends State

@export var idle_state: State
@export var run_state: State
@export var jump_state: State
@export var change_dir_state: State
@export var fly_state: State
@export var action_state: State
@export var cannon_state: State
@export var light_dash_state: State

var movement
	
func process_input() -> State:
	if Input.is_action_just_pressed("jump"):
		return fly_state
	if parent.light_dash and Input.is_action_just_pressed("action"):
		return light_dash_state
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
	if parent.hit:
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += fall_grav * delta
	if parent.i_frames.is_stopped():
		if (Input.is_action_pressed("move_right") and parent.velocity.x < 0) or (Input.is_action_pressed("move_left") and parent.velocity.x > 0):
			parent.velocity.x = move_toward(parent.velocity.x, 0, parent.stop_speed)
		elif (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
			parent.velocity.x = move_toward(parent.velocity.x, parent.MAX_SPEED * parent.direction, parent.acc)
		else:
			parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction)
		parent.animated_sprite_2d.flip_h = (parent.direction < 0)
		#parent.velocity.x = parent.speed * direction
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if parent.velocity.x == 0:
			return idle_state
		else:
			return run_state
	return null
