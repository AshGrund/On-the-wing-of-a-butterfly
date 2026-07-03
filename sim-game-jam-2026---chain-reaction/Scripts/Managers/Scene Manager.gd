extends Node

@export var sceneDirName: String
@export var loadFirstName: String

var sceneDir
var scenes:Dictionary
var currentScene:= [null, null]


# loads all the scenes in advance so that they can be instantiated later on
func _ready():
	sceneDir = DirAccess.open(sceneDirName)
	
	# can I open this folder
	if sceneDir == null: printerr("Could not open the Scenes folder"); return
	sceneDir.list_dir_begin()
	
	# load all the files and add them to the scenes array for later use
	for file: String in sceneDir.get_files():
		var scene := load(sceneDir.get_current_dir() + "/" + file)
		scenes[file.replace(".tscn", "")] = scene
	
	# instantiate the starting scene (change name as needed)
	if loadFirstName: SwitchScene(loadFirstName)

# save variables, delete the currently shown scene and instantiate the next one
func SwitchScene(scene = loadFirstName):
	# save the variables
	get_node("/root/GameManager/SaveManager").Save()
	
		# delete current scene
	if(currentScene[1]):
		currentScene[1].queue_free()
	
	# initialize new scene and make them a child of this object
	var instantiatedScene = scenes[scene].instantiate()
	currentScene = [instantiatedScene.name, instantiatedScene]
	self.add_child(currentScene[1])	

func EmptyScene():
	currentScene[1].queue_free()
	currentScene = [null, null]
