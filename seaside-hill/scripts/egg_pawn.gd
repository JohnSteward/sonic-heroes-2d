extends CharacterBody2D

@export var hp: int
@export var id: String
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var stun_effect: AnimatedSprite2D = $stun_effect
@onready var left_sight: RayCast2D = $left_sight
@onready var right_sight: RayCast2D = $right_sight
var stunned: float
var start_pos: float
var up: bool
var seen: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.init(self)
	start_pos = global_position.y

func is_damaged(damage):
	hp -= damage
	if hp <=0:
		queue_free()

func _physics_process(delta: float) -> void:
	state_machine.process_input()
	state_machine.process_frame(delta)
	state_machine.process_physics(delta)
