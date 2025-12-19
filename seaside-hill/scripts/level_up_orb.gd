extends RigidBody2D
@onready var collection: AnimationPlayer = $collection
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var type: String
var collected: bool

func initialise(spawn) -> void:
	position = spawn.global_position
	print(position)

func _ready() -> void:
	var rand = randf_range(0.0, 1.0)
	if rand < 0.33:
		animated_sprite_2d.play("speed")
		type = "speed"
	elif rand < 0.67:
		animated_sprite_2d.play("power")
		type = "power"
	else:
		animated_sprite_2d.play("fly")
		type = "flying"
	print(position)
	linear_velocity.y = -300

func _physics_process(delta: float) -> void:
	if linear_velocity.y < 0:
		linear_velocity.y += 1 * delta
	else:
		linear_velocity.y = 0.01 * delta
	

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and collected == false:
		if body.game_manager.front_char == body:
			collected = true
			if body.level < 3:
				body.level_up()
			collection.play("collect")
			print(body, "level up")
