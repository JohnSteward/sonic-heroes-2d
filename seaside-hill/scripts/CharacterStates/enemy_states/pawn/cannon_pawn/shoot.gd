extends State
@onready var delay: Timer = $delay
@onready var shoot_time: Timer = $shoot_time
@onready var bullet: Area2D = $bullet

@export var idle_state: State
@export var stun_state: State
@export var bullet_speed: float

@onready var sight: Area2D = $sight

var player_pos
var x_dist
var y_dist
func enter() -> void:
	super()
	x_dist = abs(bullet.position.x - player_pos[0])
	y_dist = abs(bullet.position.y - player_pos[1])
	if player_pos[0] <= parent.position.x:
		parent.animated_sprite_2d.flip_h = false
		parent.gun.get_node("AnimatedSprite2D").flip_h = false
		parent.gun.position = parent.left_cannon_pos.global_position
		bullet.get_node("bullet_sprite").flip_h = false
		parent.direction = 1
		if player_pos[1] < parent.gun.position.y:
			parent.gun.rotate(atan(y_dist/x_dist))
			bullet.rotate(atan(y_dist/x_dist))
		else:
			parent.gun.rotate(-atan(y_dist/x_dist))
			bullet.rotate(-atan(y_dist/x_dist))
		bullet.position = parent.gun.get_node("AnimatedSprite2D").get_node("barrel_left").global_position
	else:
		parent.animated_sprite_2d.flip_h = true
		parent.gun.get_node("AnimatedSprite2D").flip_h = true
		parent.gun.position = parent.right_cannon_pos.global_position
		bullet.get_node("bullet_sprite").flip_h = true
		parent.direction = -1
		if player_pos[1] < parent.gun.position.y:
			parent.gun.rotate(-atan(y_dist/x_dist))
			bullet.rotate(-atan(y_dist/x_dist))
		else:
			parent.gun.rotate(atan(y_dist/x_dist))
			bullet.rotate(atan(y_dist/x_dist))
		bullet.position = parent.gun.get_node("AnimatedSprite2D").get_node("barrel_right").global_position
	super()
	delay.start()
	shoot_time.start()
	
func exit() -> void:
	bullet.visible = false
	bullet.get_node("hitbox").disabled = true
	if parent.direction == 1:
		bullet.position = parent.gun.get_node("AnimatedSprite2D").get_node("barrel_right").global_position
	else:
		bullet.position = parent.gun.get_node("AnimatedSprite2D").get_node("barrel_left").global_position
	parent.sight.get_node("radius").disabled = true
	player_pos = null
	parent.gun.rotation = 0
	bullet.rotation = 0
	parent.seen = false
	

func process_frame(delta: float) -> State:
	if parent.stunned:
		return stun_state
	return null

func process_physics(delta: float) -> State:
	if delay.is_stopped():
		bullet.visible = true
		bullet.get_node("hitbox").disabled = false
		if player_pos:
			bullet.position += parent.gun.transform.x.normalized() * -parent.direction * bullet_speed * delta
			if shoot_time.is_stopped():
				return idle_state
	return null



func _on_sight_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !player_pos:
		player_pos = body.global_position
		parent.seen = true


func _on_sight_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		parent.seen = false


func _on_bullet_area_entered(area: Area2D) -> void:
	area.get_parent().is_damaged()
