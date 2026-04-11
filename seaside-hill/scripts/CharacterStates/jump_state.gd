extends State

@export var idle_state: State
@export var run_state: State
@export var fall_state: State
@export var action_state: State
@export var change_dir_state: State
@export var cannon_state: State
@export var light_dash_state: State

@export var jump_vel: float

var movement
func enter() -> void:
	super()
	parent.hit = false
	parent.hurtbox.set_collision_layer_value(3, false)
	parent.hurtbox.set_collision_layer_value(7, true)
	parent.hitbox.get_node("hitbox_shape").disabled = false
	parent.velocity.y = -jump_vel

	
func process_input() -> State:
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
		parent.velocity.y = -jump_vel
		parent.hit = false
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
		
	if parent.i_frames.is_stopped():
		if (Input.is_action_pressed("move_right") and parent.velocity.x < 0) or (Input.is_action_pressed("move_left") and parent.velocity.x > 0):
			parent.velocity.x = move_toward(parent.velocity.x, 0, parent.stop_speed)
		elif parent.moving:
			parent.velocity.x = move_toward(parent.velocity.x, parent.MAX_SPEED * parent.direction, parent.acc)
		else:
			parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction)
		parent.animated_sprite_2d.flip_h = (parent.direction < 0)
	parent.move_and_slide()
	if parent.velocity.y > 0 or !Input.is_action_pressed("jump"):
		return fall_state
	
	if parent.is_on_floor():
		if movement == 0:
			return idle_state
		else:
			return run_state
	return null
