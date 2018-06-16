extends Timer

export (PackedScene) var level_scene = preload("res://level/Main.tscn")
var spawn_queue = []
var spawner = null
var player = null


func obj_exited(type):
	spawn_queue.append("asteroid")


func _process(delta):
	if(!spawn_queue.empty() ):
		if(spawner !=null):
			pass
			spawner.obj_spawn_requested(spawn_queue.pop_front())

func register_spawner(new_spawner):
	spawner = new_spawner
	print("GAMEKEEPER: spawner registered")
	
func register_player(new_player):
	player = new_player
	print("GAMEKEEPER: player registered")
	
func new_level():
	#gets the present level, deletes it and then reinstances it
	get_tree().get_root().get_node("level").queue_free()
	var new_lvl = level_scene.instance()
	get_tree().get_root().add_child(new_lvl)
	spawn_queue = ["asteroid", "asteroid", "asteroid"]
	print("level reset")
	
func add_objects():
	spawn_queue.append("asteroid")

func _ready():
	spawn_queue = ["asteroid", "asteroid", "asteroid"]
	self.connect("timeout",self, "add_objects")
	self.wait_time = 15.0
	self.start()




