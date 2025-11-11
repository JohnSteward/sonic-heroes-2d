extends PathFollow2D

var player_in = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in:
		MoveAlongPath(player_in)

func MoveAlongPath(player: CharacterBody2D) -> void:
	progress += 10
	print(progress_ratio)
	if progress_ratio >= 1:
		player_in.out_cannon = true
		player_in.is_in_cannon = false
		player_in = null
		progress_ratio = 0
		self.get_node("RemoteTransform2D").remote_path = ""
		
