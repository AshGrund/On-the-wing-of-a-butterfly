extends Node

func _ready():
	self.pressed.connect(requestPlace)
	self.mouse_entered.connect(requestHoverAndUnHover)
	self.mouse_exited.connect(requestHoverAndUnHover)

func requestHoverAndUnHover():
	get_node("/root/GameManager").HoverAndUnhover()

func requestPlace():
	self.get_parent().PlaceItem()
