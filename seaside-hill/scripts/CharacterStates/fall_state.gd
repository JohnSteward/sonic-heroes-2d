extends State

@export var idle_state: State
@export var run_state: State
@export var change_dir_state: State
@export var fly_state: State

var direction
var movement
	
func process_input() -> State:
	direction = Input.get_axis("move_left", "move_right")
	if (parent.velocity.x > 0 and direction == -1) or (parent.velocity.x < 0 and direction == 1):
		return change_dir_state
	if Input.is_action_just_pressed("jump"):
		return fly_state
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += fall_grav * delta
	direction = Input.get_axis("move_left", "move_right")
	if parent.i_frames.is_stopped():
		if direction:
			parent.speed = move_toward(parent.speed, MAX_SPEED, acc)
			parent.animated_sprite_2d.flip_h = (direction < 0)
			parent.velocity.x = parent.speed * direction
		else:
			parent.speed = move_toward(parent.speed, 0, friction)
			if parent.velocity.x < 0:
				parent.velocity.x = parent.speed * -1
			else:
				parent.velocity.x = parent.speed
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement == 0:
			return idle_state
		else:
			return run_state
	return null
