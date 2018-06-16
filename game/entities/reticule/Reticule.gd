extends Node2D

export (float) var max_viz_distance
export (PackedScene) var shell_scene
export var lock_rate = 0.05
var present_lock = 0

func _ready():
	_set_diameter(max_viz_distance)

func increment_lock():
	present_lock += lock_rate
	_set_diameter(1/present_lock * max_viz_distance)

 

func _set_diameter(diam):
	$Reticule.position.y = -diam
	$Reticule2.position.y = diam

func _process(delta):
	self.rotation += 0.1

func detonate():
	for i in range(8):
		var shell = shell_scene.instance()
		self.get_parent().add_child(shell)
		$ShellPos.position.y = rand_range(6, max_viz_distance / present_lock)
		self.rotation = rand_range(0, 2 * PI)
		shell.global_position = $ShellPos.global_position
	self.queue_free()