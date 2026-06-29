extends Control

@export_category("Scene Change Button")
@export var scene:String

func _ready():
	var button = Button.new()
	button.text = "Scene Change"
	button.pressed.connect(requestSceneChange)
	add_child(button)

func requestSceneChange():
	get_node("/root/SceneManager").SwitchScene(scene)
