extends Node

func _ready():
	self.pressed.connect(requestPlace)

func requestPlace():
	self.get_parent().placeItem(self.name)
