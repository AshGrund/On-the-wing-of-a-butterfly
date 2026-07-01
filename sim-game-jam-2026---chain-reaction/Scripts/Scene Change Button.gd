extends Control

@export var who:String
@export var scene:String


func _ready():
	self.pressed.connect(requestSceneChange)

func requestSceneChange():
	get_node("/root/GameManager/SceneManager" + who).SwitchScene(scene)
