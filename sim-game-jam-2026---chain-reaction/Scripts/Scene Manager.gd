extends Node

var dir := DirAccess.open("res://Scenes")
var scenes:Dictionary
var currentScene:Node


# loads all the scenes in advance so that they can be instantiated later on
func _ready():
	# get all the files in the scene folder
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	
	# load all the files and add them to the scenes array for later use
	for file: String in dir.get_files():
		var scene := load(dir.get_current_dir() + "/" + file)
		print(file + "test")
		scenes[file.replace(".tscn", "")] = scene
	
	# load the starting scene (change number as needed)
	SwitchScene("Test 1")

# deleting the currently shown scene and instantiating the next one
func SwitchScene(scene):
	# delete current scene
	if(currentScene):
		currentScene.queue_free()
	
	# initialize new scene and make them a child of this object
	currentScene = scenes[scene].instantiate()
	self.add_child(currentScene)
