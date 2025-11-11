extends State

@export var idle_state: State

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super()
	parent.velocity = Vector2(0, 0)
	
func exit() -> void:
	pass

func process_frame(delta: float) -> State:
	if parent.out_cannon:
		return idle_state
	return null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func process_physics(delta: float) -> State:
	return null
