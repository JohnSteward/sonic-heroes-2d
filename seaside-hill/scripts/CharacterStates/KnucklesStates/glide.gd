extends State

@export var fall_state: State
@export var idle_state: State
@export var run_state: State
@export var change_dir_state: State
@export var cannon_state: State
@export var glide_grav: float

var direction: int
func enter() -> void:
	super()
	parent.velocity.y = glide_grav
	
func process_input() -> State:
	direction = Input.get_axis("move_left", "move_right")
	if !Input.is_action_pressed("jump"):
		return fall_state
	return null

func process_frame(delta: float) -> State:
	if parent.is_in_cannon:
		return cannon_state
	return null

func process_physics(delta: float) -> State:
	direction = Input.get_axis("move_left", "move_right")
	if parent.i_frames.is_stopped():
		parent.velocity.y = glide_grav
		if (parent.velocity.x > 0 and direction == -1) or (parent.velocity.x < 0 and direction == 1):
				parent.speed = move_toward(parent.speed, 0, parent.friction)
				parent.velocity.x = parent.speed * direction * -1
		elif direction:
			parent.speed = move_toward(parent.speed, parent.MAX_SPEED, parent.acc)
			parent.animated_sprite_2d.flip_h = (direction < 0)
			parent.velocity.x = parent.speed * direction
		else:
			parent.speed = move_toward(parent.speed, 0, parent.friction)
			if parent.velocity.x < 0:
				parent.velocity.x = parent.speed * -1
			else:
				parent.velocity.x = parent.speed
	else:
		print(parent.velocity.y)
		parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if parent.speed == 0:
			return idle_state
		else:
			return run_state
	return null
