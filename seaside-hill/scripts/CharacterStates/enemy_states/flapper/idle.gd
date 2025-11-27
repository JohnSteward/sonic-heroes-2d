extends State
@onready var sight: Area2D = $sight


@export var stun_state: State

var up: bool
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	parent.velocity = Vector2(0, 0)
	print("hi")
	up = true

func process_frame(delta: float) -> State:
	if parent.stunned:
		return stun_state
	return null

func process_physics(delta: float) -> State:
	if up:
		parent.velocity.y = -5
		if parent.position.y <= (parent.start_pos - 3):
			print("not up")
			up = false
	else:
		parent.velocity.y = 5
		if parent.position.y >= parent.start_pos + 3:
			print("going up")
			up = true
	parent.move_and_slide()
		
	return null
