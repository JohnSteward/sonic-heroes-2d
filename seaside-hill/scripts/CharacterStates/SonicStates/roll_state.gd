extends State

@export var idle_state: State
@export var run_state: State
@export var jump_state: State
@export var fall_state: State
@export var change_dir_state: State

var direction: int

func enter() -> void:
	super()
	
	
func exit() -> void:
	friction = 2

func process_input() -> State:
	direction = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	if (parent.velocity.x > 0 and direction == -1) or (parent.velocity.x < 0 and direction == 1):
		friction = 10
	return null

func process_physics(delta) -> State:
	if parent.animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	parent.speed = move_toward(parent.speed, 0, friction)
	parent.velocity.x = parent.speed * direction
	parent.move_and_slide()
	if parent.velocity.x == 0:
		return idle_state
	if !parent.is_on_floor():
		return fall_state
	
	return null
