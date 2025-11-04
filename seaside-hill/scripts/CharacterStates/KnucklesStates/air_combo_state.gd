extends State

@export var idle_state: State

func enter() -> void:
	super()
	
func process_physics(delta: float) -> State:
	return idle_state
