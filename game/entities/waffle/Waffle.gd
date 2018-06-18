extends RigidBody2D

signal overheated

func _ready():
	GAMEKEEPER.barrage.init_tracking(self)
	
func _process(delta):
	GAMEKEEPER.barrage.init_tracking(self)

		
func _on_BurnTimer_timeout():
	self.queue_free()
