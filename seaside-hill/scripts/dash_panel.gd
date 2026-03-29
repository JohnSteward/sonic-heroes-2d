extends Area2D
@onready var game_manager: Node = %GameManager
@export var dir: int
@export var vel: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.velocity = vel
