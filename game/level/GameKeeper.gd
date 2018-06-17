extends Node

export (PackedScene) var level_scene = preload("res://level/Main.tscn")
export (PackedScene) var gate_scene = preload("res://entities/gate/Gate.tscn")
var spawn_queue = []
var spawner = null
var player = null
var gate = null
var level = null


func obj_exited(type):
	spawn_queue.append("asteroid")


func _process(delta):
	if(!spawn_queue.empty() ):
		if(spawner !=null):
			pass
			spawner.obj_spawn_requested(spawn_queue.pop_front())
	if(get_tree().get_nodes_in_group("cannister").size() == 0):
		print("cannisters cleared")
		var spawn = gate_scene.instance()
		self.get_parent().add_child(spawn)
		gate = spawn
		set_process(false)
		

func register_spawner(new_spawner):
	spawner = new_spawner
	print("GAMEKEEPER: spawner registered")
	
func register_player(new_player):
	player = new_player
	print("GAMEKEEPER: player registered")
	
func register_level(new_level):
	level = new_level
	print("GAMEKEEPER: level registered")
	
func new_level():
	#gets the present level, deletes it and then reinstances it
	var new_lvl = level_scene.instance()
	level.queue_free()
	self.get_parent().add_child(new_lvl)
	spawn_queue = ["asteroid", "asteroid", "asteroid"]
	set_process(true)
	print("level reset")
	
func add_objects():
	spawn_queue.append("asteroid")

func _ready():
	spawn_queue = ["asteroid", "asteroid", "asteroid"]
	$EscalationTimer.connect("timeout",self, "add_objects")
	$EscalationTimer.wait_time = 15.0
	$EscalationTimer.start()




