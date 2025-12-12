extends Enemy

var seen: bool = false
@onready var sight: Area2D = $sight
@onready var gun: Area2D = $gun
@onready var left_cannon_pos: Node2D = $position_markers/left_cannon_pos
@onready var right_cannon_pos: Node2D = $position_markers/right_cannon_pos

func _ready() -> void:
	super()
func is_damaged(damage):
	super(damage)
	
func _physics_process(delta: float) -> void:
	super(delta)
