extends Enemy
@onready var sight: Area2D = $sight
@onready var gun: Area2D = $gun

var up: bool
var start_pos: Vector2
var seen: bool = false

func _ready() -> void:
	super()
	start_pos = global_position
func is_damaged(damage):
	super(damage)
	
func _physics_process(delta: float) -> void:
	super(delta)
