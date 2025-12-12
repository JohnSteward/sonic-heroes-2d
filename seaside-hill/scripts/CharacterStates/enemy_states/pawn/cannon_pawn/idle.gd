extends State

@export var shoot_state: State
@export var stun_state: State

func enter() -> void:
	super()
	
func process_frame(delta: float) -> State:
	if parent.seen:
		return shoot_state
	if parent.stunned:
		return stun_state
	return null

func process_physics(delta: float) -> State:
	parent.sight.get_node("radius").disabled = false
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null


func _on_sight_body_entered(body: Node2D) -> void:
	parent.seen = true
