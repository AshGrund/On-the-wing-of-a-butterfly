extends Node

func _ready():
	var paper

	# set escape cutscene
	match [
		[
			"no", 
			"no", 
			&"TheDesk", 
			"no"
		], 
		[
			"no", 
			"no", 
			&"TheDesk", 
			"no"
		]
	]:
		[[_, _, var a, _], ["no", "no", "Counter", "no"]] when a != "Counter":
			paper = 1
		[[var a, var b, var c, var d], [var w, var x, var y, var z]] when (a == w and a != "no") or (b == x and b != "no") or (c == y and c != "no") or (d == z and d != "no"):
			paper = 2
		_:
			paper = 0
	
	print(paper)
