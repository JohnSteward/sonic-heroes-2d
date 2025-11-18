extends State

@export var run_state: State
@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var roll_state: State
@export var fly_state: State
@export var action_state: State
@export var air_action_state: State
@export var cannon_state: State
@export var light_dash_state: State

var direction

func enter() -> void:
	if parent.is_on_floor():
		parent.animated_sprite_2d.play("change_dir")
	#parent.animated_sprite_2d.flaip_h = !parent.animated_sprite_2d.flip_h

func exit() -> void:
	parent.move_and_slide()

func process_frame(delta: float) -> State:
	if parent.is_on_floor() and !(parent.animated_sprite_2d.animation == "change_dir"):
		parent.animated_sprite_2d.play("change_dir")
	if parent.is_in_cannon:
		return cannon_state
	return null


func process_input() -> State:
	direction = Input.get_axis("move_left", "move_right")
	if parent.is_on_floor() and Input.is_action_just_pressed("jump"):
		return jump_state
	if !(parent.velocity.x > 0 and direction == -1) and !(parent.velocity.x < 0 and direction == 1):
		return run_state
	if parent.is_on_floor() and Input.is_action_pressed("roll"):
		return roll_state
	if !parent.is_on_floor() and Input.is_action_just_pressed("jump"):
		return fly_state
	if parent.light_dash and Input.is_action_just_pressed("action"):
		return light_dash_state
	if parent.is_on_floor() and Input.is_action_just_pressed("action"):
		parent.animated_sprite_2d.flip_h = !parent.animated_sprite_2d.flip_h
		return action_state
	if !parent.is_on_floor() and Input.is_action_just_pressed("action"):
		return air_action_state
	return null

func process_physics(delta: float) -> State:
	if !parent.is_on_floor() and !Input.is_action_pressed("jump"):
		parent.velocity.y += fall_grav * delta
	else:
		parent.velocity.y += gravity * delta
	direction = Input.get_axis("move_left", "move_right")
	if parent.i_frames.is_stopped():
		if direction:
			parent.speed = move_toward(parent.speed, 0, friction)
			parent.velocity.x = parent.speed * direction * -1
		else:
			return run_state
	elif !parent.i_frames.is_stopped() and parent.is_on_floor():
		return idle_state
	parent.move_and_slide()
	if parent.velocity.x == 0:
		if parent.velocity.y > 0:
			return fall_state
		if direction:
			return run_state
		elif parent.is_on_floor():
			return idle_state
		
	
	return null
	
