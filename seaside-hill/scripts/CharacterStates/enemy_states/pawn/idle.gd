extends State
#WANT TO MAKE HIM WANDER TO A SPECIFIED POINT, STOP FOR A SECOND, MOVE TO ANOTHER POINT
@export var charge_state: State
@export var stun_state: State

@onready var delay: Timer = $delay
var distance: int 
var walking: bool = false
var waypoint: float
var seen: bool = false
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super()
	delay.start()
	distance = randi() % 40 + 30
	waypoint = parent.position.x + (parent.direction*distance)
	walking = true
	if parent.direction == 1:
		parent.sword.position = parent.right_sword_pos.global_position
	else:
		parent.sword.position = parent.left_sword_pos.global_position

func process_frame(delta: float) -> State:
	if parent.stunned:
		return stun_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	if parent.left_sight.is_colliding() and parent.direction == -1:
		return charge_state
	elif parent.right_sight.is_colliding() and parent.direction == 1:
		return charge_state
	if delay.is_stopped():
		if !walking:
			distance = randi() % 40 + 30
			# Change direction each time he stops
			if parent.direction == 1:
				parent.direction = -1
				parent.animated_sprite_2d.flip_h = false
				parent.sword.position = parent.left_sword_pos.global_position
			else:
				parent.direction = 1
				parent.animated_sprite_2d.flip_h = true
				parent.sword.position = parent.right_sword_pos.global_position
			waypoint = parent.position.x + (parent.direction*distance)
			walking = true
		else:
			parent.position.x = move_toward(parent.position.x, waypoint, parent.walk_speed*delta)
			print(parent.direction)
		if parent.position.x == waypoint:
			print("hiiiiii")
			delay.start()
			walking = false
	parent.move_and_slide()
	return null
