extends Node

var sceneDir := DirAccess.open("res://Scenes")
var saveDir := DirAccess.open("res://Saves")
var scenes:Dictionary
var currentScene:Node
var variables := ConfigFile.new()


# loads all the scenes in advance so that they can be instantiated later on
func _ready():
	# get all the files in the scene folder
	if sceneDir == null: printerr("Could not open the Scenes folder"); return
	sceneDir.list_dir_begin()
	
	# load all the files and add them to the scenes array for later use
	for file: String in sceneDir.get_files():
		var scene := load(sceneDir.get_current_dir() + "/" + file)
		scenes[file.replace(".tscn", "")] = scene
	
	# try to load the scene save file
	if saveDir == null: printerr("Could not open the Saves folder"); return
	saveDir.list_dir_begin()
	var err = variables.load(saveDir.get_current_dir() + "/" + "Scene Changes.cfg")
	
	# there is no save file yet, make one
	if err != OK:
		variables.save(saveDir.get_current_dir() + "/" + "Scene Changes.cfg")
	
	# instantiate the starting scene (change name as needed)
	SwitchScene("Test 1")

# save variables, delete the currently shown scene and instantiate the next one
func SwitchScene(scene):
	# save the variables
	variables.save(saveDir.get_current_dir() + "/" + "Scene Changes.cfg")
	
	# delete current scene
	if(currentScene):
		currentScene.queue_free()
	
	# initialize new scene and make them a child of this object
	currentScene = scenes[scene].instantiate()
	self.add_child(currentScene)

func GetVariable(scene, object):
	if !variables.get_value(scene, object):
		variables.set_value(scene, object, 0)
	
	return variables.get_value(scene, object)

func ChangeVariable(scene, object, value):
	variables.set_value(scene, object, value)
