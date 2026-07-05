extends Node

var inventory := [null, null, null]
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
		item = item.replace(".remap", "")
		print(item)
		var loadedItem := load(itemDir.get_current_dir() + "/" + item)
		itemList[item.replace(".tscn", "")] = loadedItem
		
		# check if it should be in a slot and add it if needed
		
		if get_node("/root/GameManager/SaveManager").GetVariable("Inventory", item.replace(".tscn", "")) != "no":
			AttemptPickUp(item)
		
	# show the selected slot
	var tempStr = str(selectedSlot)
	self.find_child(tempStr).find_child("Selected").show()

# adds items to the inventory from picking them up
func AttemptPickUp(item):
	# check for an available slot
	var i = 0
	while inventory[i]:
		i += 1
	
	if i >= 3: return false
	else:
		# instantiate item parent it to the slot and put it in the inventory array
		inventory[i] = itemList[item.replace(".tscn", "")].instantiate()
		var tempStr = str(i)
		self.find_child(tempStr).find_child("ItemPlace").add_child(inventory[i])
		return true

# removes item for inventory to place it
func AttemptPlace():
	# check if there i something in the slot, if there is return the name and remove it from the slot
	if inventory[selectedSlot]:
		var itemName = inventory[selectedSlot].name
		inventory[selectedSlot].queue_free()
		inventory[selectedSlot] = null
		
		return itemName
	# there is nothing in the slot return false
	else: return false

# change the selected slot
func ChangeSelectedSlot(slot:int):
	var tempStr = str(selectedSlot)
	self.find_child(tempStr).find_child("Selected").hide()
	selectedSlot = slot
	tempStr = str(selectedSlot)
	self.find_child(tempStr).find_child("Selected").show()
