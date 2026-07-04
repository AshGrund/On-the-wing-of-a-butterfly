extends Node

func _ready():
	self.pressed.connect(pauseAndUnpauseRequest)
	self.mouse_entered.connect(requestHoverAndUnHover)
	self.mouse_exited.connect(requestHoverAndUnHover)

func requestHoverAndUnHover():
	get_node("/root/GameManager").HoverAndUnhover()

func pauseAndUnpauseRequest():
	get_node("/root/GameManager").pauseAndUnpause()
