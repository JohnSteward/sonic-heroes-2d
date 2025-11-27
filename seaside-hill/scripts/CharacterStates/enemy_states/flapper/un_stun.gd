extends State

@export var idle_state: State

func enter() -> void:
	super()
	parent.velocity.y = -30
	
func process_frame(delta: float) -> State:
	if parent.position.y <= parent.start_pos:
		return idle_state
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	return null
