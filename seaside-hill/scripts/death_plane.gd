extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.rings = 0
	body.is_damaged()
