extends RigidBody2D

export (PackedScene) var heat_mesh_scene
export (PackedScene) var waffle_scene
export (float) var stat_engine_strength
export (float) var stat_engine_heat
export (float) var stat_thruster_strength
export (float) var stat_thermal_buffer
export (float) var stat_thermal_bleed_rate
export (float) var stat_max_mass
export (float) var stat_waffle_cost
export (float) var stat_waffle_temp
export (int) var stat_max_health

onready var engine_strength = stat_engine_strength
onready var engine_heat = stat_engine_heat
onready var thruster_strength = stat_thruster_strength
onready var thermal_buffer = stat_thermal_buffer
onready var thermal_bleed_rate = stat_thermal_bleed_rate
onready var max_health = stat_max_health
onready var max_mass = stat_max_mass
onready var waffle_cost = stat_waffle_cost
onready var waffle_temp = stat_waffle_temp
onready var temperature = 0
onready var damage = 0
onready var immobile = false
onready var dead = false
onready var stored_mass = 15

signal overheated
signal heat_updated
signal life_updated
signal mass_updated
signal player_died

func _ready():
	$EngineTarget.position.y = -engine_strength
	$ThrusterTarget.position.x = thruster_strength
	GAMEKEEPER.register_player(self)
	emit_signal("life_updated", max_health-damage)
	emit_signal("mass_updated", stored_mass)
	print("ship spawned")
	
func _process(delta):
	if (temperature > 0):
		temperature -= thermal_bleed_rate
	if (temperature > thermal_buffer):
		GAMEKEEPER.barrage.init_tracking(self)
	if (temperature > thermal_buffer * 3):
		temperature = thermal_buffer * 3 
	emit_signal("heat_updated", temperature)
	
	#handle mass
	if (stored_mass >= max_mass):
		stored_mass = max_mass

func _integrate_forces(state):
	self.applied_force = Vector2()
	#handle input
	#direction assumes ship is looking up, along -y
	var direction = Vector2()
	if(Input.is_action_pressed("player_forward")):
		direction.y -= 1
	if(Input.is_action_pressed("player_brake")):
		direction.y += 1
	if(Input.is_action_pressed("player_turn_left")):
		direction.x -= 1
	if(Input.is_action_pressed("player_turn_right")):
		direction.x += 1
	if(dead):
		direction = Vector2()
	if (immobile):
		direction.y = 0
	#handle reactions
	if(direction.y < 0):
		self.fire_engine(direction.y)
		$EngineTrail.emitting = true
	else:
		$EngineTrail.emitting = false
	if(direction.x !=0):
		fire_thruster(direction.x)

func _physics_process(delta):
	#handle deploying mass_net
	if(Input.is_action_just_pressed("player_deploy_mesh")):
		immobile = true
		var spawn = heat_mesh_scene.instance()
		self.add_child(spawn)
		spawn.player = self
	#handle firing off waffle
	if(Input.is_action_just_pressed("player_fire_waffle")):
		if(stored_mass > waffle_cost):
			var spawn = waffle_scene.instance()
			self.get_parent().add_child(spawn)
			spawn.global_position = self.global_position
			spawn.linear_velocity = Vector2(0,100).rotated(self.rotation)
			stored_mass -= waffle_cost
			emit_signal("mass_updated", stored_mass)
			if(temperature - waffle_temp > 0):
				temperature -= waffle_temp
			else: 
				temperature =0


func fire_engine(strength):
	var pos = ($EngineTarget.global_position - self.global_position)
	self.applied_force= pos * -1
	self.temperature += engine_heat
	if(!$EngineSound.playing):
		$EngineSound.play()


func fire_thruster(strength):
	#expects a value from -1 to 1
	self.angular_velocity += strength * thruster_strength / 500
	

func _on_ShipBody_body_entered(body):
	#this should handle damage and collecting cannisters
	if(body.is_in_group("cannister")):
		body.collect(self)
		self.temperature += 3
	elif(body.is_in_group("asteroid")):
		accept_damage(1)


func accept_damage(damage_amount):
	damage += damage_amount
	emit_signal("life_updated", max_health-damage)
	$HitSound.play()
	if (damage >= max_health and !dead):
		emit_signal("player_died")
		dead = true
		$DeathTimer.start()
		$DeathSound.play()
		


func _on_DeathTimer_timeout():
	GAMEKEEPER.to_menu()
	


func _on_VisibilityNotifier2D_screen_exited():
	accept_damage(16)