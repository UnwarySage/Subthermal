extends "res://entities/DriftingObject.gd"
var disabled  = false

func collect(collector):
	SCOREKEEPER.adjust_score(15)
	disabled = true
	self.queue_free()

func _on_VizNote_screen_exited():
	if(!disabled):
		.offscreen()
