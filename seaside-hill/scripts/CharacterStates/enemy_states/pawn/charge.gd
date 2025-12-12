extends State
@export var search_state: State
@export var stun_state: State

@onready var delay: Timer = $delay
@onready var charge_time: Timer = $charge_time

var end_charge: bool = false

func enter() -> void:
	super()
	delay.start()
	if parent.animated_sprite_2d.flip_h:
		parent.direction = 1
		parent.sword.global_position = parent.get_node("right_sword_pos").global_position
	else:
		parent.direction = -1
		parent.sword.global_position = parent.get_node("left_sword_pos").global_position
	print("charge")

func exit() -> void:
	parent.velocity.x = 0
	end_charge = false

func process_frame(delta: float) -> State:
	if end_charge:
		return search_state
	if parent.stunned:
		return stun_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	if delay.is_stopped():
		if charge_time.is_stopped():
			charge_time.start()
		else:
			parent.velocity.x = parent.direction * parent.run_speed
	parent.move_and_slide()
	return null


func _on_charge_time_timeout() -> void:
	end_charge = true
