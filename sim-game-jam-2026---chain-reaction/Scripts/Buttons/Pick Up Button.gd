extends Node

func _ready():
	self.pressed.connect(requestPickUp)

func requestPickUp():
	self.get_parent().PickUpItem(self.name)
