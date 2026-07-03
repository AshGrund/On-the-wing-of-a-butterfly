extends Node

var itemList := ["Keys", "BrokenKeys", "Cheese", "Bread", "Eggs", "Warning", "Phone", "Bills", "Notepad", "Documents"]
var sceneManager
var majorScene
var minorScene
var itemsHere:Array

func _ready():
	sceneManager = get_node("/root/GameManager/SceneManager")
	majorScene = sceneManager.currentScene[0]
	minorScene = get_node("/root/GameManager/SceneManager/" + majorScene).currentScene[0]
	
	for item in itemList:
		if get_node("/root/GameManager/SaveManager").GetVariable(majorScene, item) == minorScene:
			get_node("/root/GameManager/SceneManager/" + majorScene + "/" + minorScene + "/" + item).show()
			itemsHere.append(item)

func placeItem():
	var itemName = get_node("/root/GameManager/InventoryManager").attemptPlace()
	if(itemName):
		get_node("/root/GameManager/SaveManager").changeVariable(majorScene, itemName, minorScene)
		get_node("/root/GameManager/SaveManager").changeVariable("Inventory", itemName, false)
		get_node("/root/GameManager/SceneManager/" + majorScene + "/" + minorScene + "/" + itemName).show()
		itemsHere.append(itemName)

func pickUpItem(item):
	if(get_node("/root/GameManager/InventoryManager").attemptPickUp(item)):
		get_node("/root/GameManager/SaveManager").changeVariable(majorScene, item, false)
		get_node("/root/GameManager/SaveManager").changeVariable("Inventory", item, true)
		get_node("/root/GameManager/SceneManager/" + majorScene + "/" + minorScene + "/" + item).hide()
		itemsHere.erase(item)
