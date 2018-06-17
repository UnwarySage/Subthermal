extends Area2D
onready var player
var active = false
var repairing = false
var multiplier = 0

func ready():
	$MeshAnim.play("deploy")

func _physics_process(delta):
	if(player !=null && active):
		player.thermal_bleed_rate = 2
		player.stored_mass += 0.05 + multiplier * 3
		if(player.stored_mass >= player.max_mass):
			player.stored_mass = player.max_mass
			init_repair()
		player.emit_signal("mass_updated", player.stored_mass)
		if(!Input.is_action_pressed("player_deploy_mesh")):
			$MeshAnim.play("pack")
			$DeploySound.play()
			active = false
			$RepairTimer.stop()

func _on_MeshAnim_animation_finished(anim_name):
	if(anim_name == "pack"):
		self.visible = false
		player.immobile = false
		player.thermal_bleed_rate = player.stat_thermal_bleed_rate
		self.queue_free()
	elif(anim_name == "deploy"):
		active = true

func init_repair():
	if(player.damage > 0 and !repairing):
		print("Init Repair")
		$RepairTimer.start()
		repairing = true

func _on_MeshArea_body_entered(body):
	if(body.is_in_group("asteroid")):
		multiplier +=1

func _on_MeshArea_body_exited(body):
	if(body.is_in_group("asteroid")):
		multiplier -=1

func _on_RepairTimer_timeout():
	if(active):
		print("repaired damage")
		repairing = false
		if(player.damage > 0):
			player.damage -=1
			player.stored_mass =0
			player.emit_signal("life_updated",player.max_health - player.damage)
			$RepairSound.play()
	
