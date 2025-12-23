extends Area2D
var player: CharacterBody2D
@onready var path_2d: Path2D = $Path2D
@onready var game_manager = %GameManager


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and game_manager.front_char == body:
		player = body
		path_2d.get_node("PathFollow2D/RemoteTransform2D").remote_path = player.get_path()
		path_2d.get_node("PathFollow2D").player_in = player
		
