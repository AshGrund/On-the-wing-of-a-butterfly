extends Node

func _ready():
	self.pressed.connect(requestPickUp)
	self.mouse_entered.connect(requestHoverAndUnHover)
	self.mouse_exited.connect(requestHoverAndUnHover)

func requestHoverAndUnHover():
	get_node("/root/GameManager").HoverAndUnhover()

func requestPickUp():
	self.get_parent().PickUpItem(self.name)
