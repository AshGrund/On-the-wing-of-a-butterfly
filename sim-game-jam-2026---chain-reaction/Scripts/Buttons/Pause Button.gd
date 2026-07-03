extends Node

func _ready():
	self.pressed.connect(pauseAndUnpauseRequest)

func pauseAndUnpauseRequest():
	get_node("/root/GameManager").pauseAndUnpause()
