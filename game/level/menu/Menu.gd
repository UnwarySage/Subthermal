extends Control

export (PackedScene) var scorebox_scene

var lain_low = false

func _ready():
	if(SCOREKEEPER.present_score != 0):
		$CentralCollumn/MainMenu/PresentScoreBox/HiScoreDisplay.text = str(SCOREKEEPER.present_score)
		$CentralCollumn/MainMenu/PresentScoreBox.visible = true
	else:
		$CentralCollumn/MainMenu/PresentScoreBox.visible = false
	$CentralCollumn/MainMenu/NextLevelButton.grab_focus()
		
func _on_NextLevelButton_pressed():
	GAMEKEEPER.enabled = true
	GAMEKEEPER.new_level()
	SCOREKEEPER.present_score = 0
	self.queue_free()
	
func _on_RetireButton_pressed():
	lain_low = true
	if($CentralCollumn/ScoreContainer.visible):
		$CentralCollumn/ScoreContainer.visible = false
	else:
		_display_scores()
		$CentralCollumn/ScoreContainer.visible = true

func _on_HelpButton_pressed():
	$CentralCollumn/HelpScreen.visible = !$CentralCollumn/HelpScreen.visible

func _on_ExitButton_pressed():
	print("exiting")
	get_tree().quit()

func _on_CloseHelp_pressed():
	$CentralCollumn/HelpScreen.visible = false
	
func _display_scores():
	$CentralCollumn/ScoreContainer/ScoreScreen/YourScoreBox/HiScoreDisplay.text = str(SCOREKEEPER.present_score)
	$CentralCollumn/ScoreContainer/ScoreScreen/HiScoreBox/HiScoreDisplay.text = str(SCOREKEEPER.high_score)
	
	var index = 1
	for score in SCOREKEEPER.prev_scores:
		var box = scorebox_scene.instance()
		box.get_node("HiScoreName").text = ("RUN_" + str(index) + ":")
		box.get_node("HiScoreDisplay").text = str(score)
		$CentralCollumn/ScoreContainer/ScoreScreen.add_child(box)
		index += 1
	
