extends RigidBody2D
@onready var collection: AnimationPlayer = $collection
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	var rand = randfn(0.0, 1.0)
	if rand < 0.33:
		animated_sprite_2d.play("speed")
	elif rand < 0.67:
		animated_sprite_2d.play("power")
	else:
		animated_sprite_2d.play("fly")
	linear_velocity.y = -500

func _physics_process(delta: float) -> void:
	if linear_velocity.y < 0:
		linear_velocity.y += 1 * delta
	else:
		linear_velocity.y = 0.01 * delta
	

func _on_area_body_entered(body: Node2D) -> void:
	if body.level < 3:
		body.level_up()
	collection.play("collect")
