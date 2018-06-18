extends VBoxContainer
var life_icon_scene = preload("res://entities/player/LifeIcon.tscn")
var player = null



func _on_ShipBody_heat_updated(new_val):
	$HBoxContainer/ThermalGauge.value = new_val
	$HBoxContainer/ThermalGauge.max_value = player.thermal_buffer

func _on_ShipBody_life_updated(new_val):
	adjust_life_icons(new_val)

func adjust_life_icons(new_amount):
	for child in $LifeContainer.get_children():
		child.queue_free()
	for val in range(new_amount):
		var child = life_icon_scene.instance()
		$LifeContainer.add_child(child)

func _on_ShipBody_mass_updated(new_val):
	$HBoxContainer/MassGauge.value = new_val
	$HBoxContainer/MassGauge.max_value = player.max_mass
	if (player.waffle_cost < new_val):
		self.get_node("../WaffleReadyIcon").frame =0
	else:
		self.get_node("../WaffleReadyIcon").frame =1
		
