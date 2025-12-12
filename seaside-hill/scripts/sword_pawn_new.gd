extends Enemy
@onready var left_sight: RayCast2D = $left_sight
@onready var right_sight: RayCast2D = $right_sight
@onready var sword: Area2D = $sword
@onready var left_sword_pos: Node2D = $position_markers/left_sword_pos
@onready var right_sword_pos: Node2D = $position_markers/right_sword_pos
@onready var charge_left: Node2D = $position_markers/charge_left
@onready var charge_right: Node2D = $position_markers/charge_right


var start_pos: Vector2
var seen: bool = false

func _ready() -> void:
	super()
	start_pos = global_position
	
func is_damaged(damage):
	super(damage)
	
func _physics_process(delta: float) -> void:
	super(delta)
