class_name Player
extends CharacterBody2D

@onready var ui: Control = %UI
@onready var game_manager: Node = %GameManager
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $StateMachine
@onready var i_frames: Timer = $"i-frames"
@onready var hurtbox: Area2D = $hurtbox
@onready var hitbox: Area2D = $hitbox

@export var knockback_state: State
@export var behind_state: State
@export var next_char: CharacterBody2D
@export var prev_char: CharacterBody2D
@onready var damage_sound: AudioStreamPlayer2D = $damage_sound
@onready var remote_transform_2d: RemoteTransform2D = %RemoteTransform2D

@export var MAX_SPEED: float
@export var friction: float
@export var acc: float

var level: int = 0
var hit: bool = false
var speed: int = 0
var damage: int = 1
var can_fly: bool = false
var start_fly_x: float
var start_fly_y: float
var is_in_cannon: bool = false
var out_cannon: bool = false
var light_dash: bool = false
var ring_position

func _ready() -> void:
	state_machine.init(self)


func change_char(current_char, dir) -> void:
	var game_cam = preload("res://scenes/game_cam.tscn").instantiate()
	current_char.get_node("Game_Cam").queue_free()
	if dir > 0:
		game_manager.front_char = current_char.next_char
	else:
		game_manager.front_char = current_char.prev_char
	game_manager.front_char.add_child(game_cam)
	game_manager.front_char.position = current_char.position

func spawn_rings(no_rings) -> void:
	var ring_spawner = preload("res://scenes/ring.tscn")
	var y_vel = 100
	for i in range(no_rings):
		var x_vel = randf_range(-50, 50)
		var ring = ring_spawner.instantiate()
		ring.initialise(x_vel, y_vel, true)

func knockback():
	var direction
	var no_rings = game_manager.rings
	if animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	velocity.x = 200 * direction * -1
	velocity.y = -400
	move_and_slide()
	spawn_rings(no_rings)

func _physics_process(delta: float) -> void:
	ui.update_rings(game_manager.rings)
	if !game_manager.front_char == self and !state_machine.current_state == behind_state:
		state_machine.change_state(behind_state)
	state_machine.process_input()
	state_machine.process_frame(delta)
	state_machine.process_physics(delta)
	
func is_damaged() -> void:
	damage_sound.play()
	if i_frames.is_stopped():
		if game_manager.rings == 0:
			get_tree().reload_current_scene()
		else:
			game_manager.rings = 0
			knockback()
			i_frames.start()


func level_up() -> void:
	level += 1
	damage += 1

func _on_light_dash_radius_area_entered(area: Area2D) -> void:
	if area.is_in_group("ring"):
		light_dash = true
		ring_position = area.get_parent().position


func _on_light_dash_radius_area_exited(area: Area2D) -> void:
	if area.is_in_group("ring") and area.get_parent().position == ring_position:
		light_dash = false
