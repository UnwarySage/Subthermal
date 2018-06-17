extends Node
export (String) var type


func offscreen():
	self.queue_free()

func _on_VisNote_screen_exited():
	offscreen()

