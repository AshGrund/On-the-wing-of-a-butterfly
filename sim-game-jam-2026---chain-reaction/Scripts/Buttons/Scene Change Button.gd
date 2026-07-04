extends Control

@export var who:String
@export var scene:String
@export var dynamic:bool

var dynamicScene

func _ready():
	self.pressed.connect(requestSceneChange)
	self.mouse_entered.connect(requestHoverAndUnHover)
	self.mouse_exited.connect(requestHoverAndUnHover)

func requestHoverAndUnHover():
	get_node("/root/GameManager").HoverAndUnhover()

func requestSceneChange():
	if dynamic:
		dynamicScene = scene + get_node("/root/GameManager").currentState
	else: dynamicScene = scene
	
	if dynamicScene:
		get_node("/root/GameManager/SceneManager" + who).SwitchScene(dynamicScene)
	else:
		get_node("/root/GameManager/SceneManager" + who).SwitchScene()
		
