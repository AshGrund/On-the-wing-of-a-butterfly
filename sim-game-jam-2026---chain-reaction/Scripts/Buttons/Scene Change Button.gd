extends Control

@export var who:String
@export var scene:String
@export var dynamic:bool

var dynamicWho

func _ready():
	self.pressed.connect(requestSceneChange)

func requestSceneChange():
	if dynamic:
		dynamicWho = get_node("/root/GameManager").currentState + who
	else: dynamicWho = who
	
	if scene:
		get_node("/root/GameManager/SceneManager" + dynamicWho).SwitchScene(scene)
	else:
		get_node("/root/GameManager/SceneManager" + dynamicWho).SwitchScene()
		
