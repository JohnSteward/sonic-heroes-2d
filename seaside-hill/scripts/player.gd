class_name Player
extends CharacterBody2D

@onready var ui: Control = %UI
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $StateMachine
@onready var i_frames: Timer = $"i-frames"
@onready var hurtbox: Area2D = $hurtbox
@onready var hitbox: Area2D = $hitbox

@export var knockback_state: State
@onready var damage_sound: AudioStreamPlayer2D = $damage_sound
@onready var remote_transform_2d: RemoteTransform2D = %RemoteTransform2D

var level: int = 0
var hit: bool = false
var speed: int = 0
var damage: int = 1
var rings: int = 0
var can_fly: bool = false
var start_fly_x: float
var start_fly_y: float
var is_in_cannon: bool = false
var out_cannon: bool = false
var light_dash: bool = false
var ring_position

func _ready() -> void:
	state_machine.init(self)


func knockback():
	var direction
	if animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	velocity.x = 200 * direction * -1
	velocity.y = -400
	move_and_slide()
	state_machine.change_state(knockback_state)

func _physics_process(delta: float) -> void:
	ui.update_rings(rings)
	state_machine.process_input()
	state_machine.process_frame(delta)
	state_machine.process_physics(delta)
	
func is_damaged() -> void:
	damage_sound.play()
	if i_frames.is_stopped():
		if rings == 0:
			get_tree().reload_current_scene()
		else:
			rings = 0
			knockback()
			i_frames.start()


func level_up() -> void:
	level += 1
	damage += 1

func _on_light_dash_radius_area_entered(area: Area2D) -> void:
	if area.is_in_group("ring"):
		light_dash = true
		ring_position = area.position


func _on_light_dash_radius_area_exited(area: Area2D) -> void:
	if area.is_in_group("ring") and area.position == ring_position:
		light_dash = false
