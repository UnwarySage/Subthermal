extends RigidBody2D

func collect(collector):
	SCOREKEEPER.adjust_score(15)
	self.queue_free()