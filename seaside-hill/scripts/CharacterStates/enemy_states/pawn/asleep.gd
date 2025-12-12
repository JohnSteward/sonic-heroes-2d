extends State
# SLEEPY ANIMATION, NO MOVING

@export var charge_state: State



func enter() -> void:
	super()
	if parent.animated_sprite_2d.flip_h:
		parent.direction = 1
	else: 
		parent.direction = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process_frame(delta: float) -> State:
	if (parent.left_sight.is_colliding() and parent.direction == -1) or (parent.right_sight.is_colliding() and parent.direction == 1):
		return charge_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
