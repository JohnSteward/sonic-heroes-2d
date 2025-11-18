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
var direction;

func enter() -> void:
	super()
	parent.can_fly = true
	parent.hurtbox.get_node("CollisionShape2D").disabled = false

#func exit() -> void:
	#speed = 0
	
func process_input() -> State:
	direction = Input.get_axis("move_left", "move_right")
	if parent.is_on_floor() and Input.is_action_just_pressed("jump"):
		return jump_state
	if parent.is_on_floor() and Input.is_action_just_pressed("roll"):
		return roll_state
	if (parent.velocity.x > 0 and direction == -1) or (parent.velocity.x < 0 and direction == 1):
		return change_dir_state
	if parent.light_dash and Input.is_action_just_pressed("action"):
		return light_dash_state
	if Input.is_action_just_pressed("action"):
		return action_state
	return null
	
func process_frame(delta: float) -> State:
	if parent.speed >= MAX_SPEED and (!parent.animated_sprite_2d.animation == "sprint"):
		parent.animated_sprite_2d.play("sprint")
	if parent.is_in_cannon:
		return cannon_state
	return null
	
func process_physics(delta: float) -> State:
	direction = Input.get_axis("move_left", "move_right")
	if parent.i_frames.is_stopped():
		if parent.velocity.x > MAX_SPEED:
			parent.animated_sprite_2d.play("sprint")
			if parent.animated_sprite_2d.flip_h:
				direction = -1
			else:
				direction = 1
			parent.speed = move_toward(parent.speed, MAX_SPEED, friction)
			parent.velocity.x = parent.speed * direction

		elif direction:
			parent.speed = move_toward(parent.speed, MAX_SPEED, acc)
			movement = direction * parent.speed
			parent.animated_sprite_2d.flip_h = (direction < 0)
			parent.velocity.x = movement
		else:
			parent.speed = move_toward(parent.speed, 0, friction)
			# Check which direction we are moving in
			if parent.velocity.x < 0:
				parent.velocity.x = parent.speed * -1
			else:
				parent.velocity.x = parent.speed
	elif !parent.i_frames.is_stopped() and parent.is_on_floor():
		return idle_state
	parent.move_and_slide()
	if !parent.is_on_floor():
		return fall_state
	if parent.velocity.x == 0:
		return idle_state
	return null
