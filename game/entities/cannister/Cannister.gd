extends "res://entities/DriftingObject.gd"
var disabled  = false

func collect(collector):
	SCOREKEEPER.adjust_score(15)
	disabled = true
	self.queue_free()
	collector.get_node("CollectSound").play()
	
func _on_VizNote_screen_exited():
	if(!disabled):
		.offscreen()

func _on_CannisterBody_body_entered(body):
	if(body.is_in_group("asteroids")):
		self.applied_force = (self.global_position - body.global_position).normalized() * 128
		

