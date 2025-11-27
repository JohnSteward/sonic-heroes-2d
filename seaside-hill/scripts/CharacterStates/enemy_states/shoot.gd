extends State
@onready var delay: Timer = $delay
@onready var bullet: Area2D = $bullet

@export var idle_state: State
@export var stun_state: State

@onready var sight: Area2D = $sight

var player_pos: Vector2
var x_dist: float
var y_dist: float
var direction: int
func enter() -> void:
	if player_pos[0] <= parent.position.x:
		parent.animated_sprite_2d.flip_h = false
		direction = 1
	else:
		parent.animated_sprite_2d.flip_h = true
		direction = -1
	bullet.position = Vector2(parent.position.x - (7*direction), parent.position.y + (8*direction))
	super()
	delay.start()
	
func exit() -> void:
	bullet.position = Vector2(parent.position.x - 7, parent.position.y + 8)
	bullet.visible = false
	parent.sight.get_node("radius").disabled = true
	parent.seen = false
	

func process_frame(delta: float) -> State:
	if parent.stunned:
		return stun_state
	return null

func process_physics(delta: float) -> State:
	if delay.is_stopped():
		bullet.visible = true
		if player_pos:
			bullet.position.x = move_toward(bullet.position.x, player_pos[0], 3)
			bullet.position.y = move_toward(bullet.position.y, player_pos[1], 3/(x_dist/y_dist))
			if bullet.position == player_pos:
				return idle_state
	return null



func _on_sight_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_pos = body.global_position
		x_dist = abs(bullet.global_position.x - player_pos[0])
		y_dist = abs(bullet.global_position.y - player_pos[1])
		parent.seen = true


func _on_sight_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		parent.seen = false
