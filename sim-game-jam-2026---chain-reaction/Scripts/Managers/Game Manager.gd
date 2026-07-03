extends Node
var paused = false
var showingInventory = false
var currentState = "Current"

# make sure everything keeps working without weird screens being shown
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and get_node("SceneManagerCurrent").currentScene[0] != "MainMenu" and get_node("SceneManagerPast").currentScene[0] != "MainMenu":
		pauseAndUnpause()
	if get_node("SceneManagerCurrent").currentScene[0] == "MainMenu" and paused:
		pauseAndUnpause()
	if get_node("SceneManagerPast").currentScene[0] == "MainMenu" and paused:
		pauseAndUnpause()
	if get_node("SceneManagerPast").currentScene[0] == "MainMenu" and showingInventory:
		get_node("InventoryManager").hide()
		showingInventory = false
	if get_node("SceneManagerCurrent").currentScene != [null, null] and showingInventory:
		get_node("InventoryManager").hide()
		showingInventory = false
	if get_node("SceneManagerPast").currentScene != [null, null] and get_node("SceneManagerPast").currentScene[0] != "MainMenu" and !showingInventory:
		get_node("InventoryManager").show()
		showingInventory = true
	
	if currentState == "Current" and get_node("SceneManagerPast").currentScene != [null, null]:
		get_node("SceneManagerPast").EmptyScene()
	elif currentState == "Past" and get_node("SceneManagerCurrent").currentScene != [null, null]:
		get_node("SceneManagerCurrent").EmptyScene()

# pause and unpause the game
func pauseAndUnpause():
	if(!paused):
		get_node("SceneManagerCurrent").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("SceneManagerPast").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("SoundManager").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("InventoryManager").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("PauseScreen").show()
		paused = true
	else:
		get_node("SceneManagerCurrent").process_mode = Node.PROCESS_MODE_INHERIT
		get_node("SceneManagerPast").process_mode = Node.PROCESS_MODE_INHERIT
		get_node("SoundManager").process_mode = Node.PROCESS_MODE_INHERIT
		get_node("InventoryManager").process_mode = Node.PROCESS_MODE_INHERIT
		get_node("PauseScreen").hide()
		paused = false
