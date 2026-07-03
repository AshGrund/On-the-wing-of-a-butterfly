extends Node

@export var where:String

func _ready():
	self.pressed.connect(requestGoToCurrent)

func requestGoToCurrent():
	get_node("/root/GameManager/SceneManagerPast").EmptyScene()
	get_node("/root/GameManager/SceneManagerCurrent").SwitchScene(where)
	get_node("/root/GameManager").currentState = "Current"
	get_node("/root/GameManager").CalculateCurrent()
