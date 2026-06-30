extends Node

@export var sceneDirName: String
@export var saveName: String
@export var loadFirstName: String

var sceneDir
var saveDir := DirAccess.open("res://Saves")
var scenes:Dictionary
var currentScene:Node
var variables := ConfigFile.new()


# loads all the scenes in advance so that they can be instantiated later on
func _ready():
	sceneDir = DirAccess.open(sceneDirName)
	# get all the files in the scene folder
	if sceneDir == null: printerr("Could not open the Scenes folder"); return
	sceneDir.list_dir_begin()
	
	# load all the files and add them to the scenes array for later use
	for file: String in sceneDir.get_files():
		var scene := load(sceneDir.get_current_dir() + "/" + file)
		scenes[file.replace(".tscn", "")] = scene
	
	# try to load the scene save file
	if saveName:
		if saveDir == null: printerr("Could not open the Saves folder"); return
		saveDir.list_dir_begin()
		var err = variables.load(saveDir.get_current_dir() + "/" + saveName + ".cfg")
	
		# there is no save file yet, make one
		if err != OK:
			variables.save(saveDir.get_current_dir() + "/" + saveName + ".cfg")
	
	# instantiate the starting scene (change name as needed)
	SwitchScene(loadFirstName)

# save variables, delete the currently shown scene and instantiate the next one
func SwitchScene(scene):
	# save the variables
	if saveName:
		variables.save(saveDir.get_current_dir() + "/" + saveName + ".cfg")
	
		# delete current scene
		if(currentScene):
			currentScene.queue_free()
	
		# initialize new scene and make them a child of this object
		currentScene = scenes[scene].instantiate()
		self.add_child(currentScene)

func GetVariable(scene, object):
	if saveName:
		if !variables.get_value(scene, object):
			variables.set_value(scene, object, "base")
	
		return variables.get_value(scene, object)

func ChangeVariable(scene, object, value):
	if saveName:
		variables.set_value(scene, object, value)
