extends State

var objects_inside = []
var closest_enemy: CharacterBody2D
@onready var radius: Area2D = $radius

func enter() -> void:
	super()
	radius.position = parent.position
	radius.get_node("range").disabled = false
	closest_enemy = null
	for enemy in objects_inside:
		if !closest_enemy:
			closest_enemy = enemy
		else:
			if abs(enemy.global_position - parent.global_position) < abs(closest_enemy.global_position - parent.global_position):
				closest_enemy = enemy
	

func exit() -> void:
	radius.get_node("range").disabled = true
	closest_enemy = null
	objects_inside = []
	
func process_physics(delta: float) -> State:
	return null


#Use the array of enemies inside the range to then check for closest enemy if there is one and go for it
func _on_radius_body_entered(body: Node2D) -> void:
	objects_inside.append(body)


func _on_radius_body_exited(body: Node2D) -> void:
	objects_inside.remove(body)
