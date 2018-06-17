extends VBoxContainer
var life_icon_scene = preload("res://entities/player/LifeIcon.tscn")



func _on_ShipBody_heat_updated(new_val):
	$HBoxContainer/ThermalGauge.value = new_val
	$HBoxContainer/ThermalGauge.max_value = self.get_parent().get_parent().thermal_buffer

func _on_ShipBody_life_updated(new_val):
	adjust_life_icons(new_val)

func adjust_life_icons(new_amount):
	for child in $LifeContainer.get_children():
		child.queue_free()
	for val in range(new_amount):
		var child = life_icon_scene.instance()
		$LifeContainer.add_child(child)

func _physics_process(delta):