extends Node2D

var active_track = false
var present_signature_pos = Vector2()
var present_reticule = null
export (PackedScene) var reticule_scene

func create_reticule(target):
	var spawn = reticule_scene.instance()
	present_reticule = spawn
	spawn.target_node = target
	spawn.handler = self
	self.add_child(spawn)
	$BarrageTimer.start()
	active_track = true

func init_tracking(target):
	if(!active_track):
		print("signature aquired")
		create_reticule(target)
	else:
		present_reticule.target_node = target
		present_reticule.tighten_lock()

func _on_BarrageTimer_timeout():
	if(present_reticule != null):
		present_reticule.detonate()
		present_reticule = null
		active_track = false

func _ready():
	active_track = false
	present_signature_pos = Vector2()
	present_reticule = null
	GAMEKEEPER.register_barrage(self)
	GAMEKEEPER.connect("new_player",self,"new_player")
	
	
func new_player(new):
	new.connect("overheated", self, "tracking")
	print("BarrageHandler: connected player: " + str(new))

func redirect_track(new_track):
	if(present_reticule != null):
		present_reticule.target_node = new_track
	else:
		init_tracking(new_track)