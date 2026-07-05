extends Node
var paused = false
var showingInventory = false
var currentState = "Current"
var saveManager
var sceneManager
var inventoryManager
var soundManager
var pauseScreen
var dialogueLabel
var currentLine
var resource
var normalCursor
var hoverCursor
var hovering = false


func _ready() -> void:
	saveManager = get_node("SaveManager")
	sceneManager = get_node("SceneManager")
	inventoryManager = get_node("InventoryManager")
	soundManager = get_node("SoundManager")
	pauseScreen = get_node("PauseScreen")
	dialogueLabel = get_node("DialogueLabel")
	resource = load("res://Dialogs/EndScene.dialogue")
	normalCursor = load("res://Textures/Cursor/pointer_a.png")
	hoverCursor = load("res://Textures/Cursor/hand_point.png")
	
	saveManager.Reset()
	
	Input.set_custom_mouse_cursor(normalCursor)

# make sure everything keeps working without weird screens being shown
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and sceneManager.currentScene[0] != "MainMenu":
		pauseAndUnpause(true)
	if sceneManager.currentScene[0] == "MainMenu" and paused:
		pauseAndUnpause(true)
	if sceneManager.currentScene[0] == "MainMenu" and showingInventory or sceneManager.currentScene[0] == "PrisonRoomCurrent" and showingInventory:
		inventoryManager.hide()
		showingInventory = false
	if sceneManager.currentScene[0] != "PrisonRoomCurrent" and sceneManager.currentScene[0] != "MainMenu" and !showingInventory:
		inventoryManager.show()
		showingInventory = true



# pause and unpause the game
func pauseAndUnpause(menu):
	if(!paused):
		sceneManager.process_mode = Node.PROCESS_MODE_DISABLED
		soundManager.process_mode = Node.PROCESS_MODE_DISABLED
		inventoryManager.process_mode = Node.PROCESS_MODE_DISABLED
		if menu: pauseScreen.show()
		paused = true
		print(paused)
	else:
		sceneManager.process_mode = Node.PROCESS_MODE_INHERIT
		soundManager.process_mode = Node.PROCESS_MODE_INHERIT
		inventoryManager.process_mode = Node.PROCESS_MODE_INHERIT
		if menu: pauseScreen.hide()
		paused = false
		print(paused)

func HoverAndUnhover():
	if(hovering):
		Input.set_custom_mouse_cursor(normalCursor)
		hovering = false
	else:
		Input.set_custom_mouse_cursor(hoverCursor)
		hovering = true

func CalculateCurrent():
	get_node("SceneManager/PrisonRoomCurrent/Butterfly").hide()
	
	var _coffeeMachine
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
			Globals.foodCutscene = 0
		[1, 0]:
			Globals.foodCutscene = 1
		[0, 0]:
			Globals.foodCutscene = 2
	
	# set talkCutscene
	match [phone, paper]:
		[var a, 1] when a != 2:
			Globals.talkCutscene = 1
		[2, 2]:
			Globals.talkCutscene = 2
		[_,_]:
			Globals.talkCutscene = 0
	
	# set escapeCutscene
	match [Globals.foodCutscene, phone, paper, keys, ID]:
		[2, 2, 2, 0, 1]: # they go with haste, you can break the ropes and can get out + you report them
			Globals.escapeCutscene = 7
		[2, 2, 2, 0, 0]: # they go with haste, you can break the ropes and can get out, you can't report them
			Globals.escapeCutscene = 6
		[2, 2, 2, 1, _]:  # they go with haste, you can break the ropes but can't get out
			Globals.escapeCutscene = 5
		[var a, 2, 2, _, _] when a < 2: # they go with haste, but you can't break the ropes
			Globals.escapeCutscene = 4
		[2, var a, var b, _, _] when (a == 0 and b > 0) or (a == 1 and b > 0) or (a == 2 and b < 2):  # they go without haste, you can break the ropes and can't get out
			Globals.escapeCutscene = 3
		[2, var a, var b, _, _] when a != 2 and b == 0: # they don't go, you can break the ropes
			Globals.escapeCutscene = 2
		[var a, var b, var c, _, _] when a != 2 and b == 2 or a != 2 and c != 0: # they go but you can't break the ropes
			Globals.escapeCutscene = 1
		_: # they stay home and you can't do anything
			Globals.escapeCutscene = 0
	
	dialogueLabel.show()
	currentLine = await DialogueManager.get_next_dialogue_line(resource, "start")
	pauseAndUnpause(false)
	
	dialogueLabel.dialogue_line = currentLine
	dialogueLabel.type_out()


func _on_dialogue_label_finished_typing() -> void:
	currentLine = await DialogueManager.get_next_dialogue_line(resource, currentLine.next_id)
	if currentLine != null:
		await get_tree().create_timer(1).timeout
		dialogueLabel.dialogue_line = currentLine
		dialogueLabel.type_out()
	else:
		get_node("SceneManager/PrisonRoomCurrent/Butterfly").show()
		await get_tree().create_timer(1).timeout
		dialogueLabel.hide()
		pauseAndUnpause(false)
		if Globals.escapeCutscene == 6:
			sceneManager.SwitchScene("Credits")
		saveManager.Reset()
