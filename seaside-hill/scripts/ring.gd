extends RigidBody2D

@onready var animation_player: AnimationPlayer = $ring_area/AnimationPlayer
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var friction: float
@export var spawn = false

func initialise(x_vel, y_vel, spawn_set) -> void:
	self.linear_velocity = Vector2(x_vel, -y_vel)
	spawn = spawn_set

func _on_ring_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.game_manager.front_char == body and body.i_frames.is_stopped():
		body.game_manager.rings += 1
		animation_player.play("collect")
		
func _physics_process(delta: float) -> void:
	if spawn:
		print(linear_velocity)
		linear_velocity.y += gravity * delta / 10
		linear_velocity.x = move_toward(linear_velocity.x, 0, friction)
	else:
		linear_velocity = Vector2(0, 0)
		gravity_scale = 0
