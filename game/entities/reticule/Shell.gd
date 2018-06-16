extends Area2D

func _ready():
	self.global_rotation = 0
	$ExplosionSprite.visible = false
	$Countdown.wait_time += rand_range(0,0.5)
	
	
	
func detonate():
	var affected = get_overlapping_bodies()
	for target in affected:
		if(target.is_in_group("player")):
			target.accept_damage(1)
		if(target.is_class("RigidBody2d")):
			target.apply_impulse(Vector2(), self.global_position - target.global_position)
	$ExplosionSprite.visible = true
	$ExplosionSprite.playing = true
	$ExplosionSprite.rotation = rand_range(0, 2 *PI)
	

func _finished():
	self.queue_free()