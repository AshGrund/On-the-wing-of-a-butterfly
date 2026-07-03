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

func PlaceItem():
	var itemName = get_node("/root/GameManager/InventoryManager").AttemptPlace()
	if(itemName):
		get_node("/root/GameManager/SaveManager").ChangeVariable(majorScene, itemName, minorScene)
		get_node("/root/GameManager/SaveManager").ChangeVariable("Inventory", itemName, "no")
		get_node("/root/GameManager/SceneManager/" + majorScene + "/" + minorScene + "/" + itemName).show()
		itemsHere.append(itemName)

func PickUpItem(item):
	if(get_node("/root/GameManager/InventoryManager").AttemptPickUp(item)):
		get_node("/root/GameManager/SaveManager").ChangeVariable(majorScene, item, "no")
		get_node("/root/GameManager/SaveManager").ChangeVariable("Inventory", item, "yes")
		get_node("/root/GameManager/SceneManager/" + majorScene + "/" + minorScene + "/" + item).hide()
		itemsHere.erase(item)
