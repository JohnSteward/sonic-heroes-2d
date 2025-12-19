extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.game_manager.front_char == body:
		body.game_manager.rings = 0
		body.is_damaged()
