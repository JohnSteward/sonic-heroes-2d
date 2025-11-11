extends Control

var rings: int
@onready var rings_label: Label = $Rings

func update_rings(rings) -> void:
	rings_label.text = "Rings: " + str(rings)
