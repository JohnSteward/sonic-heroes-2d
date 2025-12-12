extends State

@export var stun_state: State
@export var shoot_state: State
var up: bool
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	parent.velocity = Vector2(0, 0)
	print("hi")
	up = true

func process_frame(delta: float) -> State:
	if parent.stunned:
		return stun_state
	if parent.seen:
		return shoot_state
	return null

func process_physics(delta: float) -> State:
	parent.sight.get_node("radius").disabled = false
	if up:
		parent.velocity.y = -5
		if parent.position.y <= (parent.start_pos[1] - 3):
			up = false
	else:
		parent.velocity.y = 5
		if parent.position.y >= parent.start_pos[1] + 3:
			up = true
	parent.move_and_slide()
		
	return null
