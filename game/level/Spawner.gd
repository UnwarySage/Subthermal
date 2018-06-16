extends Path2D

export (PackedScene) var cannister
export (PackedScene) var asteroid

func _ready():
	GAMEKEEPER.register_spawner(self)

func spawn_obj(scene):
    $SpawnLocation.set_offset(randi())
    # create a Mob instance and add it to the scene
    var spawn = scene.instance()
    add_child(spawn)
    # set the mob's direction perpendicular to the path direction
    var direction = $SpawnLocation.rotation + PI/2
    # set the mob's position to a random location
    spawn.position = $SpawnLocation.position
    # add some randomness to the direction
    direction += rand_range(-PI/4, PI/4)
    spawn.rotation = direction
    # choose the velocity
    spawn.linear_velocity = Vector2(rand_range(120, 150), 0).rotated(direction)

func scene_from_type(inp_type):
	match inp_type:
		"asteroid": return asteroid
		"cannister": return cannister

func obj_spawn_requested(type):
	spawn_obj(scene_from_type(type))
	print("GAMEKEEPER:spawned " + type)