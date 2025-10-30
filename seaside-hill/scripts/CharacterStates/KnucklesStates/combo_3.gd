extends State

@export var run_state: State
@export var idle_state: State

@onready var punch_start: Timer = $punch_start
@onready var punch_end: Timer = $punch_end
@onready var punch_3_left: Area2D = $punch_3_left
@onready var punch_3_right: Area2D = $punch_3_right
@onready var left_anim: AnimatedSprite2D = $punch_3_left/left_anim
@onready var right_anim: AnimatedSprite2D = $punch_3_right/right_anim

var end_combo: bool = false
var direction: int
var input: int

func enter() -> void:
	super()
	if parent.animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	end_combo = false
	punch_start.start()
	left_anim.flip_h = true
	punch_3_left.position.y = parent.position.y
	punch_3_right.position.y = parent.position.y
	parent.velocity.y = -200
	parent.velocity.x = 120 * direction
	parent.move_and_slide()
	
func exit() -> void:
	end_combo = false
	punch_3_left.get_node("hitbox_left").disabled = true
	punch_3_right.get_node("hitbox_right").disabled = true
	left_anim.visible = false
	right_anim.visible = false
	parent.hurtbox.get_node("CollisionShape2D").disabled = false

	
func process_physics(delta: float) -> State:
	input = Input.get_axis("move_left", "move_right")
	parent.velocity.y += gravity * delta
	if parent.is_on_floor():
		punch_3_left.get_node("hitbox_left").disabled = false
		punch_3_right.get_node("hitbox_right").disabled = false
		punch_3_left.position.x -= 5
		punch_3_right.position.x += 5
		parent.velocity.x = 0
		left_anim.visible = true
		right_anim.visible = true
		left_anim.play("punch")
		right_anim.play("punch")
	else:
		punch_3_left.position.x = parent.position.x
		punch_3_right.position.x = parent.position.x
		parent.velocity.x = 120 * direction
		left_anim.visible = false
		right_anim.visible = false
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


func _on_punch_3_right_area_entered(area: Area2D) -> void:
	area.get_parent().is_damaged(parent.damage)


func _on_punch_3_left_area_entered(area: Area2D) -> void:
	area.get_parent().is_damaged(parent.damage)
