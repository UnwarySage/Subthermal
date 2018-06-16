extends Node
export (String) var type


func offscreen():
	GAMEKEEPER.obj_exited(type)
	self.queue_free()

func _on_VisNote_screen_exited():
	offscreen()

