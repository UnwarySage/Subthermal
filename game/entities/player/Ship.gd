extends RigidBody2D

export (float) var stat_engine_strength
export (float) var stat_engine_heat
export (float) var stat_thruster_strength
export (float) var stat_thermal_buffer

onready var engine_strength = stat_engine_strength
onready var engine_heat = stat_engine_heat
onready var thruster_strength = stat_thruster_strength
onready var thermal_buffer = stat_thermal_buffer
onready var temperature = 0

func _ready():
	$EngineTarget.position.y = -engine_strength
	$ThrusterTarget.position.x = thruster_strength

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
	if(direction.x !=0):
		fire_thruster(direction.x)

func fire_engine(strength):
	var pos = ($EngineTarget.global_position - self.global_position)
	self.applied_force= pos * -1
	self.temperature += engine_heat

func fire_thruster(strength):
	#expects a value from -1 to 1
	self.angular_velocity += strength * thruster_strength / 500
	