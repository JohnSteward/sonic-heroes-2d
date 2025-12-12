extends Enemy

var up: bool
var start_pos: Vector2

func _ready() -> void:
	super()
	start_pos = global_position
func is_damaged(damage):
	super(damage)
	
	
func _physics_process(delta: float) -> void:
	super(delta)
