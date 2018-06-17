extends Node2D

export (Vector2) var screen_size = Vector2(1024,600)
export (PackedScene) var cannister_scene
export (float) var cannister_spawn_margin = 60


func _ready():
	GAMEKEEPER.register_level(self)
	screen_size = get_viewport_rect().size 
	for i in range(rand_range(4,7)):
		$LevelSweeper.position = Vector2(rand_range(cannister_spawn_margin, screen_size.x -cannister_spawn_margin),rand_range(cannister_spawn_margin, screen_size.y -cannister_spawn_margin))
		var spawn = cannister_scene.instance()
		spawn.global_position = $LevelSweeper.global_position
		self.add_child(spawn)