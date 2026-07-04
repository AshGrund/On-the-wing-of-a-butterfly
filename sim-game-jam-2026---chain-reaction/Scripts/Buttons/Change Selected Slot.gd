extends Node

func _ready():
	self.pressed.connect(requestChangeSelectedSlot)

func requestChangeSelectedSlot():
	get_node("/root/GameManager/InventoryManager").ChangeSelectedSlot(int(self.get_parent().name))
