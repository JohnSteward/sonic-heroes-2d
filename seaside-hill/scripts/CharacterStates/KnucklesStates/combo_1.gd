extends State

@export var idle_state: State
@export var run_state: State
@export var combo_2_state: State


@onready var punch_1: Area2D = $punch_1
@onready var punch_start: Timer = $punch_start
@onready var punch_end: Timer = $punch_end
@onready var animated_sprite_2d: AnimatedSprite2D = $punch_1/AnimatedSprite2D

var end_combo: bool = false
var direction: int
var input: int

func enter() -> void:
	super()
	var input = Input.get_axis("move_left", "move_right")
	parent.hurtbox.get_node("CollisionShape2D").disabled = true
	end_combo = false
	punch_start.start()
	punch_1.get_node("hitbox").disabled = false
	if input:
		direction = input
		punch_1.position.x = parent.position.x + (10*direction)
		if direction == 1:
			parent.animated_sprite_2d.flip_h = false
			animated_sprite_2d.flip_h = false
		elif direction == -1:
			parent.animated_sprite_2d.flip_h = true
			animated_sprite_2d.flip_h = true
	elif parent.animated_sprite_2d.flip_h:
		punch_1.position.x = parent.position.x - 10
		animated_sprite_2d.flip_h = true
		direction = -1
	else:
		direction = 1
		punch_1.position.x = parent.position.x + 10
		animated_sprite_2d.flip_h = false
	punch_1.position.y = parent.position.y - 5
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("punch")
	
func exit() -> void:
	end_combo = false
	punch_1.get_node("hitbox").disabled = true
	animated_sprite_2d.visible = false
	
func process_input() -> State:
	if Input.is_action_just_pressed("action") and punch_start.is_stopped() and !punch_end.is_stopped():
		return combo_2_state
	return null
	
func process_physics(delta: float) -> State:
	input = Input.get_axis("move_left", "move_right")
	parent.velocity.x = 240 * direction
	punch_1.position.x += 4  * direction
	if end_combo and !input:
		return idle_state
	elif end_combo and input:
		return run_state
	parent.move_and_slide()
	return null
	

func _on_punch_start_timeout() -> void:
	punch_end.start()


func _on_punch_end_timeout() -> void:
	end_combo = true


func _on_punch_1_area_entered(area: Area2D) -> void:
	area.get_parent().is_damaged(parent.damage)
