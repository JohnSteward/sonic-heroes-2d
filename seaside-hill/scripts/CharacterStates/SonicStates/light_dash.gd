extends State

@export var idle_state: State
# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func enter() -> void:
	super()

func process_frame(delta: float) -> State:
	if parent.light_dash:
		parent.position = parent.ring_position
	else:
		return idle_state
	return null
