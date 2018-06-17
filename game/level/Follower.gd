extends Position2D

var follow = null

func _ready():
	follow = self.get_parent()
	self.get_parent().get_parent().add_child(self)
	
func _physics_process(delta):
	self.global_position = follow.global_position
	self.global_rotation = 0