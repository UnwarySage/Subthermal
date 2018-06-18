extends Area2D

func _on_GateArea_body_exited( body ):
	if(body.is_in_group("player")):
		self.queue_free()
		SCOREKEEPER.adjust_score(100)
		SCOREKEEPER.add_score_to_table()
		GAMEKEEPER.to_menu()
		