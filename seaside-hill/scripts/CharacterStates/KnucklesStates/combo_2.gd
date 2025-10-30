extends State

@export var combo_3_state: State
@export var run_state: State
@export var idle_state: State

@onready var punch_start: Timer = $punch_start
@onready var punch_end: Timer = $punch_end
@onready var punch_2: Area2D = $punch_2
@onready var animated_sprite_2d: AnimatedSprite2D = $punch_2/AnimatedSprite2D
var end_combo: bool = false
var direction: int
var input: int

func enter() -> void:
	super()
	end_combo = false
	punch_start.start()
	punch_2.get_node("hitbox").disabled = false
	if parent.animated_sprite_2d.flip_h:
		punch_2.position.x = parent.position.x - 15
		animated_sprite_2d.flip_h = true
		direction = -1
	else:
		direction = 1
		punch_2.position.x = parent.position.x + 15
		animated_sprite_2d.flip_h = false
	punch_2.position.y = parent.position.y
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("punch")
	
func exit() -> void:
	end_combo = false
	punch_2.get_node("hitbox").disabled = true
	animated_sprite_2d.visible = false
	

func process_input() -> State:
	if Input.is_action_just_pressed("action") and punch_start.is_stopped() and !punch_end.is_stopped():
		return combo_3_state
	return null
	
func process_physics(delta: float) -> State:
	input = Input.get_axis("move_left", "move_right")
	parent.velocity.x = 360 * direction
	punch_2.position.x += 6  * direction
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


func _on_punch_2_area_entered(area: Area2D) -> void:
	area.get_parent().is_damaged(parent.damage)
