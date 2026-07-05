extends Control

func _ready() -> void:
	get_node("/root/GameManager").CalculateCurrent()
