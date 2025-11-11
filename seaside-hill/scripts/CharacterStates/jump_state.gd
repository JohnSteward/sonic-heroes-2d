extends State

@export var idle_state: State
@export var run_state: State
@export var fall_state: State
@export var action_state: State
@export var change_dir_state: State
@export var cannon_state: State

@export var jump_vel: float = 200

var movement
var direction
func enter() -> void:
	super()
	parent.velocity.y = -jump_vel

	
func process_input() -> State:
	direction = Input.get_axis("move_left", "move_right")
	if (parent.velocity.x > 0 and direction == -1) or (parent.velocity.x < 0 and direction == 1):
		return change_dir_state
	if Input.is_action_just_pressed("action"):
		return action_state
	return null
	
func process_frame(delta: float) -> State:
	if parent.is_in_cannon:
		return cannon_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
		
	direction = Input.get_axis("move_left", "move_right")
	if parent.i_frames.is_stopped():
		if direction:
			if (direction > 0 and parent.velocity.x < 0) or (direction < 0 and parent.velocity.x > 0):
				parent.speed = move_toward(parent.speed, 0, 10)
				parent.velocity.x = parent.speed * direction * -1
			else:
				parent.speed = move_toward(parent.speed, MAX_SPEED, acc)
				parent.velocity.x = parent.speed * direction
			parent.animated_sprite_2d.flip_h = (direction < 0)
		else:
			parent.speed = move_toward(parent.speed, 0, friction)
			if parent.animated_sprite_2d.flip_h:
				parent.velocity.x = parent.speed * -1
			else:
				parent.velocity.x = parent.speed
	parent.move_and_slide()
	if parent.velocity.y > 0 or !Input.is_action_pressed("jump"):
		return fall_state
	
	if parent.is_on_floor():
		if movement == 0:
			return idle_state
		else:
			return run_state
	return null
