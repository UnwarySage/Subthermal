extends Area2D
onready var player
var active = false

func ready():
	$MeshAnim.play("deploy")
	
func _physics_process(delta):
	if(player !=null && active):
		print("slurp")
		player.thermal_bleed_rate = 2
		player.stored_mass += 0.05
		player.emit_signal("mass_updated", player.stored_mass)
		if(!Input.is_action_pressed("player_deploy_mesh")):
			$MeshAnim.play("pack")
			active = false

func _on_MeshAnim_animation_finished(anim_name):
	if(anim_name == "pack"):
		self.visible = false
		player.immobile = false
		player.thermal_bleed_rate = player.stat_thermal_bleed_rate
		self.queue_free()
	elif(anim_name == "deploy"):
		active = true