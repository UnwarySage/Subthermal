extends Node

export (PackedScene) var level_scene = preload("res://level/Main.tscn")
export (PackedScene) var gate_scene = preload("res://entities/gate/Gate.tscn")
export (PackedScene)var menu_scene = preload("res://level/menu/Menu.tscn")
var asteroid_amount = 4
var asteroid_escalation = 0
var spawner = null
var player = null
var gate = null
var level = null
signal new_player
var enabled = false

func _process(delta):
	if(enabled):
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
	emit_signal("new_player", player)
	
	
func register_level(new_level):
	level = new_level
	print("GAMEKEEPER: level registered")
	
func new_level():
	#gets the present level, deletes it and then reinstances it
	var new_lvl = level_scene.instance()
	self.get_parent().add_child(new_lvl)
	set_process(true)
	print("level reset")
	
func to_menu():
	enabled = false
	if(level != null):
		level.queue_free()
	if(gate != null):
		gate.queue_free()
	self.get_parent().add_child(menu_scene.instance())
	

func _on_SpawnTimer_timeout():
	if(enabled):
		if(get_tree().get_nodes_in_group("asteroid").size() < asteroid_amount + asteroid_escalation):
			spawner.obj_spawn_requested("asteroid")
		$SpawnTimer.start()

func _on_EscalationTimer_timeout():
	if(enabled):
		asteroid_escalation +=1
		$EscalationTimer.start()
		print("asteroid level: " + str(asteroid_escalation+asteroid_amount))
	
func _ready():
	randomize()
