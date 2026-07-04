extends Node

func _ready():
	self.pressed.connect(requestGoToCurrent)

func requestGoToCurrent():
	get_node("/root/GameManager/SceneManager").SwitchScene("Prison Room Current")
	get_node("/root/GameManager").currentState = "Current"
	get_node("/root/GameManager").CalculateCurrent()
