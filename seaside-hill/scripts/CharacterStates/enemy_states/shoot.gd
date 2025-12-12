extends State
@onready var delay: Timer = $delay
@onready var shoot_time: Timer = $shoot_time
@onready var bullet: Area2D = $bullet

@export var idle_state: State
@export var stun_state: State
@export var bullet_speed: float
@onready var sight: Area2D = $sight

var player_pos
var x_dist: float
var y_dist: float
func enter() -> void:
	super()
	x_dist = abs(bullet.global_position.x - player_pos[0])
	y_dist = abs(bullet.global_position.y - player_pos[1])
	if player_pos[0] <= parent.position.x:
		parent.animated_sprite_2d.flip_h = false
		parent.gun.get_node("AnimatedSprite2D").flip_h = false
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
		bullet.get_node("bullet_sprite").flip_h = true
		parent.direction = -1
		if player_pos[1] < parent.gun.position.y:
			parent.gun.rotate(-atan(y_dist/x_dist))
			bullet.rotate(-atan(y_dist/x_dist))
		else:
			parent.gun.rotate(atan(y_dist/x_dist))
			bullet.rotate(atan(y_dist/x_dist))
		bullet.position = parent.gun.get_node("AnimatedSprite2D").get_node("barrel_right").global_position
	delay.start()
	shoot_time.start()
	#print(parent.gun.transform.rotate.normalized())
		
func exit() -> void:
	bullet.visible = false
	if parent.direction == 1:
		bullet.position = parent.gun.get_node("AnimatedSprite2D").get_node("barrel_right").global_position
	else:
		bullet.position = parent.gun.get_node("AnimatedSprite2D").get_node("barrel_left").global_position
	player_pos = null
	parent.sight.get_node("radius").disabled = true
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
