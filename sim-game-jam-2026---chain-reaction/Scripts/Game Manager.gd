extends Node
var paused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and get_node("SceneManager").currentScene[0] != "Main Menu":
		pauseAndUnpause()
	if get_node("SceneManager").currentScene[0] == "Main Menu" and paused:
		pauseAndUnpause()

func pauseAndUnpause():
	if(!paused):
		get_node("SceneManager").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("SoundManager").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("PauseScreen").show()
		paused = true
	else:
		get_node("SceneManager").process_mode = Node.PROCESS_MODE_INHERIT
		get_node("SoundManager").process_mode = Node.PROCESS_MODE_INHERIT
		get_node("PauseScreen").hide()
		paused = false
