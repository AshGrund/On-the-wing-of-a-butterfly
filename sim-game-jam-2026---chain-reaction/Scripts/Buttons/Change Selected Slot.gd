extends Node

func _ready():
	self.pressed.connect(requestChangeSelectedSlot)

func requestChangeSelectedSlot():
	self.get_parent().get_parent().ChangeSelectedSlot(int(self.get_parent().name))
