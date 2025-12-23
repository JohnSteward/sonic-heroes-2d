extends Area2D
@export var spring_height: float

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.velocity.y = -spring_height
