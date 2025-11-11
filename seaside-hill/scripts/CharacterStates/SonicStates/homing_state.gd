extends State

var closest_enemy: CharacterBody2D
var x_distance: float
var y_distance: float
var direction
var hit: bool = false
var start_pos_x: float
var start_pos_y: float
var dist_ratio: float
@onready var radius: Area2D = $radius
@onready var hitbox: Area2D = $hitbox

@export var idle_state: State
@export var jump_state: State
@export var run_state: State
@export var cannon_state: State



func enter() -> void:
	hitbox.get_node("hitbox_shape").disabled = false
	parent.hurtbox.get_node("CollisionShape2D").disabled = true
	radius.get_node("range").disabled = false
	super()
	hitbox.position = parent.position
	start_pos_x = parent.position.x
	start_pos_y = parent.position.y
	if parent.animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	radius.position = parent.position
	parent.velocity = Vector2(0,0)
	closest_enemy = null
	

func exit() -> void:
	radius.get_node("range").disabled = true
	closest_enemy = null
	hit = false
	parent.hurtbox.get_node("CollisionShape2D").disabled = false
	hitbox.get_node("hitbox_shape").disabled = true
	
func process_input() -> State:
	var input = Input.get_axis("move_left", "move_right")
	if hit:
		parent.velocity.x = 0
		return jump_state
	if parent.is_on_floor():
		if input:
			return run_state
		else:
			return idle_state
	return null

func process_frame(delta: float) -> State:
	if parent.is_in_cannon:
		return cannon_state
	return null

func process_physics(delta: float) -> State:
	hitbox.position = parent.position
	#Horrible if statement to check whether the player is above and facing the enemy
	if closest_enemy:
		parent.velocity = Vector2(0,0)
		parent.position.x = move_toward(parent.position.x, closest_enemy.position.x, 10)
		parent.position.y = move_toward(parent.position.y, closest_enemy.position.y - 5, 10/dist_ratio)
	else:
		parent.velocity.x = 600 * direction
		parent.velocity.y += gravity * delta
	parent.move_and_slide()
	hitbox.position = parent.position
	return null


#look at all enemies entering the range and choosing the closest one that the player is above and facing
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
	
