extends State

@export var idle_state: State
@export var fall_state: State
@export var cannon_state: State
var closest_enemy: CharacterBody2D
var x_distance: float
var y_distance: float
var direction
var checked: bool = false
var hit: bool = false
var start_pos_x: float
var start_pos_y: float
var dist_ratio: float
@onready var radius: Area2D = $radius
@onready var hitbox: Area2D = $hitbox
@onready var delay: Timer = $delay
@onready var fireball: RigidBody2D = $fireball



func enter() -> void:
	super()
	fireball.get_node("radius").get_node("range").disabled = false
	fireball.get_node("hitbox").get_node("hitbox_shape").disabled = false
	fireball.get_node("hitbox").get_node("AnimatedSprite2D").visible = true
	start_pos_x = parent.position.x
	start_pos_y = parent.position.y
	delay.start()
	fireball.position = parent.position
	if parent.animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	fireball.get_node("radius").position = parent.position
	parent.velocity = Vector2(0,0)
	parent.speed = 0
	
func exit() -> void:
	fireball.get_node("radius").get_node("range").disabled = true
	fireball.get_node("hitbox").get_node("hitbox_shape").disabled = true
	fireball.get_node("hitbox").get_node("AnimatedSprite2D").visible = false
	hit = false
	closest_enemy = null

func process_frame(delta: float) -> State:
	if parent.is_in_cannon:
		return cannon_state
	return null

func process_physics(delta: float) -> State:
	if !delay.is_stopped():
		fireball.linear_velocity = Vector2(0,0)
		pass
	else:
		if hit:
			#hitbox.position.move_toward(parent.position, 25)
			fireball.position.x = move_toward(fireball.position.x, parent.position.x, 40)
			fireball.position.y = move_toward(fireball.position.y, parent.position.y, 40)
			if fireball.position == parent.position:
				return fall_state
		elif closest_enemy:
			#hitbox.position.move_toward(closest_enemy.position, 25)
			fireball.position.x = move_toward(fireball.position.x, closest_enemy.position.x, 15)
			fireball.position.y = move_toward(fireball.position.y, closest_enemy.position.y, 15/dist_ratio)
		else:
			#hitbox.position.move_toward(Vector2(parent.position.x + (200*direction), parent.position.y + 200), 40)
			fireball.position.x = move_toward(fireball.position.x, parent.position.x + (200*direction), 15)
			fireball.position.y = move_toward(fireball.position.y, parent.position.y + 200, 15)
			if fireball.position == Vector2(parent.position.x + (200*direction), parent.position.y + 200) or fireball.linear_velocity.y == 0:
				hit = true
	return null



func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if !closest_enemy and (parent.position.y < body.position.y) and ((parent.position.x < body.position.x and direction == 1) or (parent.position.x > body.position.x and direction == -1)):
			closest_enemy = body
			x_distance = abs(closest_enemy.global_position.x - start_pos_x)
			y_distance = abs(closest_enemy.global_position.y - start_pos_y)
			dist_ratio = x_distance/y_distance
		elif closest_enemy and (abs(body.global_position - parent.global_position) < abs(closest_enemy.global_position - parent.global_position)) and (parent.position.y < body.position.y) and ((parent.position.x < body.position.x and direction == 1) or (parent.position.x > body.position.x and direction == -1)):
			closest_enemy = body
			x_distance = abs(closest_enemy.global_position.x - start_pos_x)
			y_distance = abs(closest_enemy.global_position.y - start_pos_y)
			dist_ratio = x_distance/y_distance


func _on_hitbox_area_entered(area: Area2D) -> void:
	area.get_parent().is_damaged(parent.damage)
	hit = true
