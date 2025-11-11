extends State
var objects_inside = []
var closest_enemy: CharacterBody2D
var x_distance: float
var y_distance: float
var direction
var checked: bool = false
var hit: bool = false
var start_pos_x: float
var start_pos_y: float
var backlog = []
@onready var hitbox: Area2D = $hitbox
@onready var radius: Area2D = $radius
@onready var animated_sprite_2d: AnimatedSprite2D = $ball/AnimatedSprite2D
@onready var cooldown: Timer = $cooldown
@onready var ball: RigidBody2D = $ball

@export var idle_state: State
@export var run_state: State
@export var cannon_state: State


func enter() -> void:
	hit = false
	parent.velocity.x = 0
	ball.get_node("hitbox").get_node("hitbox_shape").disabled = false
	ball.get_node("radius").get_node("range").disabled = false
	ball.get_node("AnimatedSprite2D").visible = true
	super()
	ball.position = parent.position
	start_pos_x = parent.position.x
	start_pos_y = parent.position.y
	if parent.animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	ball.get_node("radius").position = parent.position
	
	closest_enemy = null
	
	
func exit() -> void:
	animated_sprite_2d.visible = false
	ball.get_node("radius").get_node("range").disabled = true
	closest_enemy = null
	hit = false
	ball.get_node("hitbox").get_node("hitbox_shape").disabled = true
	backlog = []
	
	
#func process_input() -> State:
	#var input = Input.get_axis("move_left", "move_right")
	#if parent.is_on_floor():
		#if input:
			#return run_state
		#else:
			#return idle_state
	#return null
	
func process_frame(delta: float) -> State:
	if parent.is_in_cannon:
		return cannon_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	if hit:
		if closest_enemy and cooldown.is_stopped():
			ball.position.x = move_toward(ball.position.x, closest_enemy.position.x, 15)
			ball.position.y = move_toward(ball.position.y, closest_enemy.position.y - 5, 15)
		elif !cooldown.is_stopped():
			pass
		else:
			ball.position.x = move_toward(ball.position.x, parent.position.x, 30)
			ball.position.y = move_toward(ball.position.y, parent.position.y, 30)
			if ball.position == parent.position:
				return idle_state
	elif closest_enemy:
		ball.position.x = move_toward(ball.position.x, closest_enemy.position.x, 15)
		ball.position.y = move_toward(ball.position.y, closest_enemy.position.y - 5, 15)
	else:
		ball.position.x = move_toward(ball.position.x, (start_pos_x + (190*direction)), 50)
		if ball.position.x >= (start_pos_x + (180*direction)) and direction == 1:
			hit = true
		elif ball.position.x <= (start_pos_x + (180*direction)) and direction == -1:
			hit = true
	parent.move_and_slide()
	return null


func _on_hitbox_area_entered(area: Area2D) -> void:
	start_pos_x = ball.position.x
	start_pos_y = ball.position.y
	ball.get_node("radius").position = area.get_parent().position
	ball.position.x = area.get_parent().position.x
	area.get_parent().is_damaged(parent.damage)
	area.get_parent().stunned = true
	hit = true
	cooldown.start()
	if backlog != []:
		backlog.sort_custom(func(a, b): return abs(a.global_position - ball.get_node("radius").global_position) < abs(b.global_position - ball.get_node("radius").global_position))
		closest_enemy = backlog[0]
		backlog.remove_at(0)
	else:
		closest_enemy = null

func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and body.position != ball.get_node("radius").position:
		if !closest_enemy and ((ball.get_node("radius").position.x < body.position.x and direction == 1) or (ball.get_node("radius").position.x > body.position.x and direction == -1)):
			closest_enemy = body
			x_distance = abs(closest_enemy.global_position.x - start_pos_x)
			y_distance = abs(closest_enemy.global_position.y - start_pos_y)
		elif closest_enemy and (abs(body.global_position - ball.get_node("radius").global_position) < abs(closest_enemy.global_position - ball.get_node("radius").global_position)) and ((ball.get_node("radius").position.x < body.position.x and direction == 1) or (ball.get_node("radius").position.x > body.position.x and direction == -1)):
			backlog.append(closest_enemy)
			closest_enemy = body
			x_distance = abs(closest_enemy.global_position.x - start_pos_x)
			y_distance = abs(closest_enemy.global_position.y - start_pos_y)
		else:
			backlog.append(body)
