extends RigidBody2D
@export var angle: int
var rotation_speed: float = 0.1
var shoot: bool = false
@export var vel_y: float
@export var vel_x: float
var player = null
@onready var entry: Area2D = $entry
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var path_2d: Path2D = $Path2D
@onready var shoot_sound: AudioStreamPlayer2D = $shoot
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func check_input() -> void:
	if Input.is_action_just_pressed("jump"):
		shoot_sound.play()
		shoot = true
		path_2d.get_node("PathFollow2D").player_in = player
		path_2d.get_node("PathFollow2D").MoveAlongPath(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !shoot:
		if player:
			if !player.position == entry.get_node("CollisionShape2D").global_position:
				player.position.x = entry.get_node("CollisionShape2D").global_position.x
				player.position.y = entry.get_node("CollisionShape2D").global_position.y
			else:#if player.position == entry.get_node("CollisionShape2D").global_position:
				check_input()
				#sprite_2d.rotation = rotate_toward(sprite_2d.rotation, angle, rotation_speed)
			#if sprite_2d.rotation == angle:
	elif player:
		if player.out_cannon:
			player.out_cannon = false
			shoot = false
			player = null


func _on_entry_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		path_2d.get_node("PathFollow2D/RemoteTransform2D").remote_path = player.get_path()
		player.is_in_cannon = true
		
