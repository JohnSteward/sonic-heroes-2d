extends State

@export var idle_state: State
@export var charge_state: State

func enter() -> void:
	super()
	if parent.position.x > parent.start_pos[0]:
		parent.direction = -1
	else:
		parent.direction = 1
	if parent.direction == 1:
		parent.animated_sprite_2d.flip_h = true
		parent.sword.position = parent.right_sword_pos.global_position
	else:
		parent.animated_sprite_2d.flip_h = false
		parent.sword.position = parent.left_sword_pos.global_position
	
func process_frame(delta: float) -> State:
	if parent.position.x == parent.start_pos[0]:
		return idle_state
	if (parent.left_sight.is_colliding() and parent.direction == -1) or (parent.right_sight.is_colliding() and parent.direction == 1):
		return charge_state
	return null

func process_physics(delta: float) -> State:
	parent.position.x = move_toward(parent.position.x, parent.start_pos[0], parent.walk_speed*delta)
	return null
