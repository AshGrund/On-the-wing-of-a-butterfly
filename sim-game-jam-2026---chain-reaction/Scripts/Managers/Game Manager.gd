extends Node
var paused = false
var showingInventory = false
var currentState = "Current"
var saveManager
var sceneManager
var inventoryManager
var soundManager
var pauseScreen
var foodCutscene
var talkCutscene
var escapeCutscene

func _ready() -> void:
	saveManager = get_node("SaveManager")
	sceneManager = get_node("SceneManager")
	inventoryManager = get_node("InventoryManager")
	soundManager = get_node("SoundManager")
	pauseScreen = get_node("PauseScreen")

# make sure everything keeps working without weird screens being shown
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and sceneManager.currentScene[0] != "MainMenu":
		pauseAndUnpause()
	if sceneManager.currentScene[0] == "MainMenu" and paused:
		pauseAndUnpause()
	if sceneManager.currentScene[0] == "MainMenu" and showingInventory or sceneManager.currentScene[0] == "PrisonRoomCurrent" and showingInventory:
		inventoryManager.hide()
		showingInventory = false
	if sceneManager.currentScene[0] != "PrisonRoomCurrent" and sceneManager.currentScene[0] != "MainMenu" and !showingInventory:
		inventoryManager.show()
		showingInventory = true

# pause and unpause the game
func pauseAndUnpause():
	if(!paused):
		sceneManager.process_mode = Node.PROCESS_MODE_DISABLED
		soundManager.process_mode = Node.PROCESS_MODE_DISABLED
		inventoryManager.process_mode = Node.PROCESS_MODE_DISABLED
		pauseScreen.show()
		paused = true
	else:
		sceneManager.process_mode = Node.PROCESS_MODE_INHERIT
		soundManager.process_mode = Node.PROCESS_MODE_INHERIT
		inventoryManager.process_mode = Node.PROCESS_MODE_INHERIT
		pauseScreen.hide()
		paused = false

func CalculateCurrent():
	var coffeeMachine
	var eggs
	var bread
	var phone
	var paper
	var keys
	var ID
	
	# set coffeeMachine to value
	# to be made, doesn't affect things in current state
	
	# set phone
	match 	[
				[
					saveManager.GetVariable("LivingRoom", "Phone"), 
					saveManager.GetVariable("PrisonRoomPast", "Phone"), 
					saveManager.GetVariable("Kitchen", "Phone"), 
					saveManager.GetVariable("Hallway", "Phone")
				],
				[
					saveManager.GetVariable("LivingRoom", "Warning"),
					saveManager.GetVariable("PrisonRoomPast", "Warning"),
					saveManager.GetVariable("Kitchen", "Warning"),
					saveManager.GetVariable("Hallway", "Warning")
				]
	]:
		[[var a, var b, var c, var d], [var w, var x, var y, var z]] when (a == w and a != "no") or (b == x and a != "no") or (c == y and c!= "no") or (d == z and d != "no"):
			phone = 2
		[[var a,var b,var c, "no"], [var x, var y, var z, _]] when (a != x and a != "no") or (b != y and b != "no") or (c != z and c != "no"):
			phone = 1
		_:
			phone = 0
	
	# set eggs
	match saveManager.GetVariable("Kitchen", "Eggs"):
		"Blender":
			eggs = 0
		_:
			eggs = 1
	
	# set bread
	match saveManager.GetVariable("Kitchen", "Bread"):
		"Fridge":
			bread = 1
		_:
			bread = 0
	
	# set paper
	match 	[
				[
					saveManager.GetVariable("LivingRoom", "Bills"), 
					saveManager.GetVariable("PrisonRoomPast", "Bills"), 
					saveManager.GetVariable("Kitchen", "Bills"), 
					saveManager.GetVariable("Hallway", "Bills")
				],
				[
					saveManager.GetVariable("LivingRoom", "Notepad"),
					saveManager.GetVariable("PrisonRoomPast", "Notepad"),
					saveManager.GetVariable("Kitchen", "Notepad"),
					saveManager.GetVariable("Hallway", "Notepad")
				]
	]:
		[[_, _, var a, _], ["no", "no", "Counter", "no"]] when a != "Counter":
			paper = 1
		[[var a, var b, var c, var d], [var w, var x, var y, var z]] when (a == w and a != "no") or (b == x and b != "no") or (c == y and c != "no") or (d == z and d != "no"):
			paper = 2
		_:
			paper = 0
	
	# set keys
	match saveManager.GetVariable("Hallway", "Keys"):
		var a when a != "no":
			keys = 0
		_:
			keys = 1
	
	# set ID
	match saveManager.GetVariable("LivingRoom", "Documents"):
		"Table":
			ID = 1
		_:
			ID = 0
	
	# decide what cutscenes to play
	# set foodCutscene
	match [eggs, bread]:
		[_, 1]:
			foodCutscene = 0
		[1, 0]:
			foodCutscene = 1
		[0, 0]:
			foodCutscene = 2
	
	# set talkCutscene
	match [phone, paper]:
		[var a, 1] when a != 2:
			talkCutscene = 1
		[2, 2]:
			talkCutscene = 2
		[_,_]:
			talkCutscene = 0
	
	# set escapeCutscene
	match [foodCutscene, phone, paper, keys, ID]:
		[2, 2, 2, 0, 1]: # they go with haste, you can break the ropes and can get out + you report them
			escapeCutscene = 6
		[2, 2, 2, 0, 0]: # they go with haste, you can break the ropes and can get out, you can't report them
			escapeCutscene = 5
		[2, 2, 2, 1, _]:  # they go with haste, you can break the ropes but can't get out
			escapeCutscene = 4
		[2, var a, var b, _, _] when (a == 0 and b > 0) or (a == 1 and b > 0) or (a == 2 and b < 2):  # they go without haste, you can break the ropes and can't get out
			escapeCutscene = 3
		[2, var a, var b, _, _] when a != 2 and b == 0: # they don't go, you can break the ropes
			escapeCutscene = 2
		[var a, var b, var c, _, _] when a != 2 and b == 2 or a != 2 and c != 0: # they go but you can't break the ropes
			escapeCutscene = 1
		_: # they stay home and you can't do anything
			escapeCutscene = 0
	
	print(escapeCutscene)
