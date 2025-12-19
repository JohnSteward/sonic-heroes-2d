class_name Enemy
extends CharacterBody2D

@export var hp: int
@export var id: String
@export var run_speed: float
@export var walk_speed: float
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var stun_effect: AnimatedSprite2D = $stun_effect
@onready var hurt_sound: AudioStreamPlayer2D = $hurt_sound
@onready var death: AnimationPlayer = $death
@onready var hurtbox: Area2D = $hurtbox
@onready var game_manager = %GameManager

var stunned: bool
var direction: int = -1
#var seen: bool = false # everything but regular flapper
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.init(self)
	

func is_damaged(damage):
	hp -= damage
	if hp <=0:
		var rand = randf_range(0.0, 1.0)
		if rand > 0.0:
			var level_up_orb = load("res://scenes/level_up_orb.tscn").instantiate()
			level_up_orb.initialise(self)
			get_parent().add_child(level_up_orb) #So the orb isn't deleted when the enemy is
		death.play("death")
	else:
		hurt_sound.play()

func _physics_process(delta: float) -> void:
	state_machine.process_input()
	state_machine.process_frame(delta)
	state_machine.process_physics(delta)
