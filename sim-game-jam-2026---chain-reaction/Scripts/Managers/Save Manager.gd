extends Node

var saveDir := DirAccess.open("res://Saves")
var saveName := "Scene Changes"
var variables := ConfigFile.new()
var variablesBackUp := ConfigFile.new()

func _ready():
	if saveDir == null: printerr("Could not open the Saves folder"); return
	saveDir.list_dir_begin()
	var err = variables.load(saveDir.get_current_dir() + "/" + saveName + ".cfg")
	
	# there is no save file yet, make one
	if err != OK:
		variables.save(saveDir.get_current_dir() + "/" + saveName + ".cfg")
	
	err =  variablesBackUp.load(saveDir.get_current_dir() + "/Reset Past State.cfg")
	

func GetVariable(scene, object):
	if !variables.get_value(object, scene):
		variables.set_value(object, scene, "no")
		Save()
	
	return variables.get_value(object, scene)

func ChangeVariable(scene, object, value):
	variables.set_value(object, scene, value)
	Save()

func Save():
		variables.save(saveDir.get_current_dir() + "/" + saveName + ".cfg")

func Reset():
	variablesBackUp.save(saveDir.get_current_dir() + "/" + saveName + ".cfg")
	variables.load(saveDir.get_current_dir() + "/" + saveName + ".cfg")
	Save()
