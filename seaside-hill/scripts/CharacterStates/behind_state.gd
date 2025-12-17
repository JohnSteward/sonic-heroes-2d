extends State
@export var idle_state: State
var follow_char: CharacterBody2D

func run(direction) -> void:
	if parent.is_on_floor():
		if parent.speed >= parent.MAX_SPEED:
			parent.animated_sprite_2d.play("sprint")
		else:
			if !parent.animated_sprite_2d.animation == "run":
				parent.animated_sprite_2d.play("run")
	parent.speed = move_toward(parent.speed, parent.MAX_SPEED, parent.acc)
	parent.velocity.x = parent.speed * direction

func change_dir(direction) -> void:
	if !parent.animated_sprite_2d.animation == "change_dir":
		parent.animated_sprite_2d.play("change_dir")
	parent.speed = move_toward(parent.speed, 0, parent.friction + 10)
	parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction + 10)

func jump(direction) -> void:
	parent.velocity.y = -500

func slow_down(direction) -> void:
	if !parent.animated_sprite_2d.animation == "run":
		parent.animated_sprite_2d.play("run")
	parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction)
	parent.speed = move_toward(parent.speed, 0, parent.friction)

func idle(direction) -> void:
	parent.animated_sprite_2d.play("idle")
	parent.velocity.x = 0
	parent.speed = 0



func enter() -> void:
	super()
	follow_char = parent.game_manager.front_char
	parent.hurtbox.get_node("CollisionShape2D").disabled = true

func exit() -> void:
	parent.hurtbox.get_node("CollisionShape2D").disabled = false

func process_frame(delta: float) -> State:
	if parent.game_manager.front_char == parent:
		return idle_state
	if parent.position.distance_to(follow_char.global_position) > 600:
		parent.position = follow_char.global_position
		parent.velocity = Vector2(0, 0)
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	if !parent.is_on_floor():
		parent.animated_sprite_2d.play("jump")
	var direction = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		jump(direction)
	if direction == 1:
		parent.animated_sprite_2d.flip_h = false
	elif direction == -1:
		parent.animated_sprite_2d.flip_h = true
	if direction:
		if (direction > 0 and parent.velocity.x < 0) or (direction < 0 and parent.velocity.x > 0):
			parent.animated_sprite_2d.flip_h = !parent.animated_sprite_2d.flip_h
			change_dir(direction)
		else:
			run(direction)
	elif !direction and parent.is_on_floor():
		if abs(parent.velocity.x) > 0:
			slow_down(direction)
		else:
			idle(direction)
	parent.move_and_slide()
	
		
	return null
