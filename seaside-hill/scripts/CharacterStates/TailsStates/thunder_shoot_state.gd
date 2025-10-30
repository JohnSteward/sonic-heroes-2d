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
@onready var hitbox: Area2D = $hitbox
@onready var radius: Area2D = $radius
@onready var animated_sprite_2d: AnimatedSprite2D = $hitbox/AnimatedSprite2D

@export var idle_state: State
@export var run_state: State


#func check_enemies() -> void:
	#for enemy in objects_inside:
		#if !closest_enemy:
			#closest_enemy = enemy
		#else:
			#if abs(enemy.global_position - parent.global_position) < abs(closest_enemy.global_position - parent.global_position):
				#closest_enemy = enemy
	#if closest_enemy:
		#x_distance = abs(closest_enemy.global_position.x - start_pos_x)
		#y_distance = abs(closest_enemy.global_position.y - start_pos_y)
		#checked = true
		
func enter() -> void:
	hit = false
	hitbox.get_node("hitbox_shape").disabled = false
	radius.get_node("range").disabled = false
	animated_sprite_2d.visible = true
	super()
	hitbox.position = parent.position
	start_pos_x = hitbox.position.x
	start_pos_y = hitbox.position.y
	if parent.animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	radius.position = parent.position
	parent.velocity = Vector2(0,0)
	closest_enemy = null
	
	
func exit() -> void:
	animated_sprite_2d.visible = false
	radius.get_node("range").disabled = true
	closest_enemy = null
	hit = false
	hitbox.get_node("hitbox_shape").disabled = true
	
	
#func process_input() -> State:
	#var input = Input.get_axis("move_left", "move_right")
	#if parent.is_on_floor():
		#if input:
			#return run_state
		#else:
			#return idle_state
	#return null
	
func process_physics(delta: float) -> State:
	#Horrible if statement to check whether the player is facing the enemy
	if hit:
		if closest_enemy:
			hitbox.position.x = move_toward(hitbox.position.x, closest_enemy.position.x, x_distance/10)
			hitbox.position.y = move_toward(hitbox.position.y, closest_enemy.position.y - 5, y_distance/10)
		else:
			hitbox.position.x = move_toward(hitbox.position.x, parent.position.x, 30)
			hitbox.position.y = move_toward(hitbox.position.y, parent.position.y, 30)
			if hitbox.position == parent.position:
				return idle_state
	elif closest_enemy:
		parent.velocity = Vector2(0,0)
		hitbox.position.x = move_toward(hitbox.position.x, closest_enemy.position.x, x_distance/10)
		hitbox.position.y = move_toward(hitbox.position.y, closest_enemy.position.y - 5, y_distance/10)
	else:
		hitbox.position.x = move_toward(hitbox.position.x, ((start_pos_x + 180)*direction), 50)
		if hitbox.position.x == ((start_pos_x + 180)*direction):
			hit = true
	parent.move_and_slide()
	return null


func _on_hitbox_area_entered(area: Area2D) -> void:
	start_pos_x = hitbox.position.x
	start_pos_y = hitbox.position.y
	radius.position = area.get_parent().position
	area.get_parent().is_damaged(parent.damage)
	hit = true
	closest_enemy = null
	#radius.get_node("range").disabled = true
	#radius.get_node("range").disabled = false

func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and body.position != radius.position:
		if !closest_enemy and (radius.position.y < body.position.y) and ((radius.position.x < body.position.x and direction == 1) or (radius.position.x > body.position.x and direction == -1)):
			closest_enemy = body
			x_distance = abs(closest_enemy.global_position.x - start_pos_x)
			y_distance = abs(closest_enemy.global_position.y - start_pos_y)
		elif closest_enemy and (abs(body.global_position - radius.global_position) < abs(closest_enemy.global_position - radius.global_position)) and (radius.position.y < body.position.y) and ((radius.position.x < body.position.x and direction == 1) or (radius.position.x > body.position.x and direction == -1)):
			closest_enemy = body
			x_distance = abs(closest_enemy.global_position.x - start_pos_x)
			y_distance = abs(closest_enemy.global_position.y - start_pos_y)
