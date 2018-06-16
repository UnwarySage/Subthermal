extends Node2D

export (float) var max_viz_distance
export (PackedScene) var shell_scene

export var lock_rate = 0.05
var present_lock = 0
var target_velocity = null

func _ready():
	_set_diameter(max_viz_distance)

func increment_lock():
	present_lock += lock_rate
	_set_diameter(1/present_lock * max_viz_distance)
	if(GAMEKEEPER.player != null):
		target_velocity = GAMEKEEPER.player.linear_velocity 

 

func _set_diameter(diam):
	$Reticule.position.y = -diam
	$Reticule2.position.y = diam

func _process(delta):
	self.rotation += 0.1

func detonate():
	var spread = max_viz_distance / present_lock
	var amount = 8
	if(present_lock > .90):
		#lock includes momentum info now, and an increased spread
		spread = 90
		amount = 12
		self.position += target_velocity
	for i in range(amount):
		var shell = shell_scene.instance()
		self.get_parent().add_child(shell)
		$ShellPos.position.y = rand_range(6, spread)
		self.rotation = rand_range(0, 2 * PI)
		shell.global_position = $ShellPos.global_position
	self.queue_free()