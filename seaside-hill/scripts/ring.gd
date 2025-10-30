extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.rings += 1
	print(body.rings)
	queue_free()
