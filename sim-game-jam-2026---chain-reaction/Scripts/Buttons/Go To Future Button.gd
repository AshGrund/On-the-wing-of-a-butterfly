extends Node

func _ready():
	self.pressed.connect(requestGoToCurrent)
	self.mouse_entered.connect(requestHoverAndUnHover)
	self.mouse_exited.connect(requestHoverAndUnHover)

func requestHoverAndUnHover():
	get_node("/root/GameManager").HoverAndUnhover()

func requestGoToCurrent():
	get_node("/root/GameManager/SceneManager").SwitchScene("Prison Room Current")
	get_node("/root/GameManager").currentState = "Current"
	get_node("/root/GameManager").CalculateCurrent()
