extends Node2D

var active_track = false
var present_signature_pos = Vector2()
var present_reticule = null
export (PackedScene) var reticule_scene
var player  = null

func tracking(pos):
	if(!active_track):
		spawn_reticule()
		print("Signature aquired")
		active_track = true
		$BarrageTimer.start()
	if(present_reticule != null):
		present_reticule.global_position = pos
		present_reticule.increment_lock()
		
func spawn_reticule():
	var spawn = reticule_scene.instance()
	self.add_child(spawn)
	present_reticule = spawn
	

func _on_BarrageTimer_timeout():
	if(present_reticule != null):
		present_reticule.detonate()
		present_reticule = null
		active_track = false

func _ready():
	active_track = false
	present_signature_pos = Vector2()
	present_reticule = null
	GAMEKEEPER.connect("new_player",self,"new_player")
	
func new_player(new):
	new.connect("overheated", self, "tracking")
	player = new
	print("BarrageHandler: connected player: " + str(new))


	
