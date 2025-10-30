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

@export var idle_state: State
@export var run_state: State


func check_enemies() -> void:
	for enemy in objects_inside:
		if !closest_enemy:
			closest_enemy = enemy
		else:
			if abs(enemy.global_position - parent.global_position) < abs(closest_enemy.global_position - parent.global_position):
				closest_enemy = enemy
	if closest_enemy:
		x_distance = abs(closest_enemy.global_position.x - start_pos_x)
		y_distance = abs(closest_enemy.global_position.y - start_pos_y)
		checked = true
		
func enter() -> void:
	checked = false
	hitbox.get_node("hitbox_shape").disabled = false
	objects_inside = []
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
	objects_inside = []
	checked = false
	hit = false
	hitbox.get_node("hitbox_shape").disabled = true
	
	
func process_input() -> State:
	var input = Input.get_axis("move_left", "move_right")
	if parent.is_on_floor():
		if input:
			return run_state
		else:
			return idle_state
	return null
	
func process_physics(delta: float) -> State:
	if !checked:
		check_enemies()
	#Horrible if statement to check whether the player is facing the enemy
	if closest_enemy and ((parent.position.x < closest_enemy.position.x and direction == 1) or (parent.position.x > closest_enemy.position.x and direction == -1)):
		parent.velocity = Vector2(0,0)
		hitbox.position.x = move_toward(parent.position.x, closest_enemy.position.x, x_distance/10)
		hitbox.position.y = move_toward(parent.position.y, closest_enemy.position.y - 5, y_distance/10)
	parent.move_and_slide()
	return null


func _on_hitbox_area_entered(area: Area2D) -> void:
	area.get_parent().is_damaged(parent.damage)
	checked = false
	objects_inside = []
	radius.position = area.get_parent().position
