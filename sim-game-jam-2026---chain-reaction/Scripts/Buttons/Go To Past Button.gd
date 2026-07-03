extends Node

func _ready():
	self.pressed.connect(requestGoToPast)

func requestGoToPast():
	get_node("/root/GameManager/SceneManagerCurrent").EmptyScene()
	get_node("/root/GameManager/SceneManagerPast").SwitchScene("Prison Room")
	get_node("/root/GameManager/SaveManager").Reset()
	get_node("/root/GameManager").currentState = "Past"
