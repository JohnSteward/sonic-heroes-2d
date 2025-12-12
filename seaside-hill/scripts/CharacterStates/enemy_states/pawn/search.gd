extends State
@onready var search_time: Timer = $search_time

@export var idle_state: State
@export var stun_state: State
@export var charge_state: State

func enter() -> void:
	super()
	search_time.start()
	
func process_frame(delta: float) -> State:
	if search_time.is_stopped():
		return idle_state
	if (parent.left_sight.is_colliding() and parent.direction == -1) or (parent.right_sight.is_colliding() and parent.direction == 1):
		return charge_state
	if parent.stunned:
		return stun_state
	return null
