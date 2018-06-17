extends RigidBody2D
export (PackedScene) var asteroid1
export (PackedScene) var asteroid2 
export (PackedScene) var asteroid3 
export (PackedScene) var asteroid4 

func _on_Timer_timeout():
	var option_list = [asteroid1, asteroid2, asteroid3,asteroid4] 
	var count = option_list.size()
	var chosen = option_list[(rand_range(0,count))].instance()
	self.get_parent().add_child(chosen)
	chosen.linear_velocity = self.linear_velocity
	chosen.global_position = self.global_position
	chosen.rotation = self.rotation
	self.queue_free()
