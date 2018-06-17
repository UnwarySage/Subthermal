extends RigidBody2D

export (float) var stat_engine_strength
export (float) var stat_engine_heat
export (float) var stat_thruster_strength
export (float) var stat_thermal_buffer
export (float) var stat_thermal_bleed_rate
export (int) var stat_max_health

onready var engine_strength = stat_engine_strength
onready var engine_heat = stat_engine_heat
onready var thruster_strength = stat_thruster_strength
onready var thermal_buffer = stat_thermal_buffer
onready var thermal_bleed_rate = stat_thermal_bleed_rate
onready var max_health = stat_max_health
onready var temperature = 0
onready var damage = 0

signal overheated
signal heat_updated
signal life_updated

func _ready():
	$EngineTarget.position.y = -engine_strength
	$ThrusterTarget.position.x = thruster_strength
	GAMEKEEPER.register_player(self)
	emit_signal("life_updated", max_health-damage)
	
func _process(delta):
	if (temperature > 0):
		temperature -= thermal_bleed_rate
	if (temperature > thermal_buffer):
		emit_signal("overheated", self.global_position)
	if (temperature > thermal_buffer * 3):
		temperature = thermal_buffer * 3 
		print("maxed heat")
	emit_signal("heat_updated", temperature)

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
	
	#handle reactions
	if(direction.y < 0):
		self.fire_engine(direction.y)
		$EngineTrail.emitting = true
	else:
		$EngineTrail.emitting = false
	if(direction.x !=0):
		fire_thruster(direction.x)


func fire_engine(strength):
	var pos = ($EngineTarget.global_position - self.global_position)
	self.applied_force= pos * -1
	self.temperature += engine_heat


func fire_thruster(strength):
	#expects a value from -1 to 1
	self.angular_velocity += strength * thruster_strength / 500
	

func _on_ShipBody_body_entered(body):
	#this should handle damage and collecting cannisters
	if(body.is_in_group("cannister")):
		body.collect(self)
	elif(body.is_in_group("asteroid")):
		accept_damage(1)


func accept_damage(damage_amount):
	damage += damage_amount
	emit_signal("life_updated", max_health-damage)
	if (damage >= max_health):
		GAMEKEEPER.new_level()
