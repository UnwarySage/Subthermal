extends Area2D

func _ready():
	self.global_rotation = 0
	
func detonate():
	var affected = get_overlapping_bodies()
	for target in affected:
		if(target.is_in_group("player")):
			target.accept_damage(1)
		if(target.is_class("RigidBody2d")):
			target.apply_impulse(Vector2(), self.global_position - target.global_position)
	self.queue_free()
	
