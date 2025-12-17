extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.game_manager.front_char == body:
		body.game_manager.rings += 1
		animation_player.play("collect")
