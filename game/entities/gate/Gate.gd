extends Area2D




func _on_GateArea_body_exited( body ):
	if(body.is_in_group("player")):
		self.queue_free()
		GAMEKEEPER.new_level()