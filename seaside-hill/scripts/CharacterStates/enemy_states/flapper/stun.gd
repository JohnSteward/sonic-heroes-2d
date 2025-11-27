extends State

@export var unstun_state: State

@onready var stun_time: Timer = $stun_time


func enter() -> void:
	print("stunned")
	parent.stun_effect.visible = true
	stun_time.start()

func exit() -> void:
	parent.stun_effect.visible = false
	parent.velocity.y = 0
	
func process_frame(delta: float) -> State:
	if !parent.stunned:
		print("go back to idle")
		return unstun_state
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null

func _on_stun_time_timeout() -> void:
	print("not stunned")
	parent.stunned = false
