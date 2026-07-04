extends Node

func _ready():
	self.pressed.connect(requestChangeSelectedSlot)
	self.mouse_entered.connect(requestHoverAndUnHover)
	self.mouse_exited.connect(requestHoverAndUnHover)

func requestChangeSelectedSlot():
	get_node("/root/GameManager/InventoryManager").ChangeSelectedSlot(int(self.get_parent().name))

func requestHoverAndUnHover():
	get_node("/root/GameManager").HoverAndUnhover()
