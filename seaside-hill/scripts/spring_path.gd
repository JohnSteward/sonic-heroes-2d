extends PathFollow2D

var player_in = null
@export var speed: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in:
		MoveAlongPath(player_in)

func MoveAlongPath(player: CharacterBody2D) -> void:
	progress += speed
	if progress_ratio >= 1:
		progress_ratio = 0
		player_in.rotation = 0
		player_in.velocity.y = -10
		player_in = null
		self.get_node("RemoteTransform2D").remote_path = ""
