extends State

@export var roll_state: State

var direction
const MAX_DASH: float = 1000
func enter() -> void:
	super()

func process_input() -> State:
	if !Input.is_action_pressed("action"):
		parent.velocity.x = parent.speed
		return roll_state
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	if Input.is_action_pressed("action"):
		if parent.speed < MAX_DASH:
			parent.speed += acc
		else:
			parent.speed = MAX_DASH
	return null
