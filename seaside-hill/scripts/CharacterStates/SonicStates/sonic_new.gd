extends Player

var light_dash: bool = false
var ring_position

func _ready() -> void:
	super()


func knockback():
	super()

func _physics_process(delta: float) -> void:
	super(delta)
	
func is_damaged() -> void:
	super()


func _on_light_dash_radius_area_entered(area: Area2D) -> void:
	if area.is_in_group("ring"):
		light_dash = true
		ring_position = area.position


func _on_light_dash_radius_area_exited(area: Area2D) -> void:
	if area.is_in_group("ring") and area.position == ring_position:
		light_dash = false
