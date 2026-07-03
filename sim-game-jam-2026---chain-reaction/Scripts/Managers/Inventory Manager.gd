extends Node

var inventory := [null, null, null, null, null]
var selectedSlot := 0
var itemDirName := "res://Objects/UI/Items"
var itemDir
var itemList:Dictionary

func _ready():
	itemDir = DirAccess.open(itemDirName)
	
	# can I open this folder
	if itemDir == null: printerr("Could not open the Items folder"); return
	itemDir.list_dir_begin()
	
	# load all the items and add them to the itemList array for later use
	# also check if an item should be added to a slot and add them to it if needed
	for item: String in itemDir.get_files():
		# add it to the itemList array
		var loadedItem := load(itemDir.get_current_dir() + "/" + item)
		itemList[item.replace(".tscn", "")] = loadedItem
		
		# check if it should be in a slot and add it if needed
		
		if get_node("/root/GameManager/SaveManager").GetVariable("Inventory", item.replace(".tscn", "")) != "no":
			attemptPickUp(item)

# adds items to the inventory from picking them up
func attemptPickUp(item):
	# check for an available slot
	var i = 0
	while inventory[i]:
		i += 1
	
	if i >= 5: return false
	else:
		# instantiate item parent it to the slot and put it in the inventory array
		inventory[i] = itemList[item].instantiate()
		self.find_child(i).find_child("ItemPlace").add_child(inventory[i])
		return true

# removes item for inventory to place it
func attemptPlace():
	# check if there i something in the slot, if there is return the name and remove it from the slot
	if inventory[selectedSlot]:
		var itemName = inventory[selectedSlot].name
		inventory[selectedSlot] = null
		
		return itemName
	# there is nothing in the slot return false
	else: return false

# change the selected slot
func changeSelectedSlot(slot:int):
	self.get_child(selectedSlot).find_child("Selected").hide()
	selectedSlot = slot
	self.get_child(selectedSlot).find_child("Selected").show()
