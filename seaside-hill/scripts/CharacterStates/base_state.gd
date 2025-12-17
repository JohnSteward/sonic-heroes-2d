class_name State
extends Node

@export var anim_name: String

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fall_grav = 2000

var parent: CharacterBody2D

func enter() -> void:
	parent.animated_sprite_2d.play(anim_name)

func exit() -> void:
	pass

func process_input() -> State:
	return null

func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	return null
