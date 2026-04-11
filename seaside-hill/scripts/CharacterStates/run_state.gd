extends State

@export var fall_state: State
@export var idle_state: State
@export var jump_state: State
@export var roll_state: State
@export var change_dir_state: State
@export var action_state: State
@export var cannon_state: State
@export var light_dash_state: State

var movement: float

func enter() -> void:
	super()
	parent.hurtbox.set_collision_layer_value(3, true)
	parent.hurtbox.set_collision_layer_value(7, false)
	parent.hitbox.get_node("hitbox_shape").disabled = true
	parent.can_fly = true

#func exit() -> void:
	#speed = 0
	
func process_input() -> State:
	if parent.is_on_floor() and Input.is_action_just_pressed("jump"):
		return jump_state
	if parent.is_on_floor() and Input.is_action_just_pressed("roll"):
		return roll_state
	if (parent.velocity.x > 0 and parent.direction == -1) or (parent.velocity.x < 0 and parent.direction == 1):
		return change_dir_state
	if parent.light_dash and Input.is_action_just_pressed("action"):
		return light_dash_state
	if Input.is_action_just_pressed("action"):
		return action_state
	if Input.is_action_just_pressed("swap_left"):
		parent.change_char(parent, -1)
	if Input.is_action_just_pressed("swap_right"):
		parent.change_char(parent, 1)
	return null
	
func process_frame(delta: float) -> State:
	if parent.velocity.x < 0:
		parent.direction = -1
	elif parent.velocity.x > 0:
		parent.direction = 1
	if abs(parent.velocity.x) >= parent.MAX_SPEED and (!parent.animated_sprite_2d.animation == "sprint"):
		parent.animated_sprite_2d.play("sprint")
	elif abs(parent.velocity.x) < parent.MAX_SPEED and (!parent.animated_sprite_2d.animation == "run"):
		parent.animated_sprite_2d.play("run")
	if parent.is_in_cannon:
		return cannon_state
	return null
	
func process_physics(delta: float) -> State:
	if parent.i_frames.is_stopped():
		if abs(parent.velocity.x) > parent.MAX_SPEED:
			print(parent.MAX_SPEED * parent.direction)
			parent.animated_sprite_2d.play("sprint")
			parent.velocity.x = move_toward(parent.velocity.x, parent.MAX_SPEED * parent.direction, parent.friction)

		elif Input.is_action_pressed("move_right"):
			if parent.direction == 1:
				parent.velocity.x = move_toward(parent.velocity.x, parent.MAX_SPEED, parent.acc)
			else:
				parent.velocity.x = move_toward(parent.velocity.x, 0, parent.stop_speed)
		elif Input.is_action_pressed("move_left"):
			if parent.direction == -1:
				parent.velocity.x = move_toward(parent.velocity.x, -parent.MAX_SPEED,  parent.acc)
				print(parent.velocity.x)
			else:
				parent.velocity.x = move_toward(parent.velocity.x, 0, parent.stop_speed)
		else:
			parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction)
	elif !parent.i_frames.is_stopped() and parent.is_on_floor():
		return idle_state
	parent.move_and_slide()
	if !parent.is_on_floor():
		return fall_state
	if parent.velocity.x == 0:
		return idle_state
	return null
