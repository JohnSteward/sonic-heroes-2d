extends CharacterBody2D

@export var hp: int
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func is_damaged(damage):
	hp -= damage
	if hp <=0:
		queue_free()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	#velocity.x = -30
	move_and_slide()
