extends Enemy
@onready var right_sight: RayCast2D = $right_sight
@onready var left_sight: RayCast2D = $left_sight

func _ready() -> void:
	super()
	
func is_damaged(damage):
	super(damage)
	
	
func _physics_process(delta: float) -> void:
	super(delta)
