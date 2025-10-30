class_name Player
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $StateMachine
@onready var i_frames: Timer = $"i-frames"
@onready var hurtbox: Area2D = $hurtbox
@export var idle_state: State

var speed: int = 0
var damage: int = 1
var rings: int = 3
var can_fly: bool = false
var start_fly_x: float
var start_fly_y: float

func _ready() -> void:
	state_machine.init(self)


func knockback():
	var direction
	if animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	velocity.x = 200 * direction * -1
	print(velocity.x)
	velocity.y = -400
	move_and_slide()
	state_machine.change_state(idle_state)

func _physics_process(delta: float) -> void:
	state_machine.process_input()
	state_machine.process_physics(delta)
	state_machine.process_frame(delta)
	
func is_damaged() -> void:
	if i_frames.is_stopped():
		if rings == 0:
			get_tree().reload_current_scene()
		else:
			rings = 0
			knockback()
			i_frames.start()


func _on_iframes_timeout() -> void:
	print("no i frames")
