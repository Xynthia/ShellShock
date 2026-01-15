extends Area3D
#onready

@onready var camera_3d: Camera3D = $Camera3D
@onready var initial_rotation : Vector3 = Vector3(0, -180, 0)


# exports
@export var trauma_reduction_rate : float = 0

@export var max_x := 10.0
@export var max_y := 10.0
@export var max_z := 5.0

@export var noise : FastNoiseLite
@export var noise_speed := 50.0

# var
var trauma := 0.0
var time := 0.0


enum dir {LEFT, RIGHT, UP, DOWN, NOTHING}
enum look_position {CENTER, LEFT, RIGHT, UP, DOWN}

var turn_time: float = 0.5
var max_angle : float = 30
var current_look_pos : look_position = look_position.CENTER

func _ready() -> void:
	GameManager.player.camera_move_time = turn_time

func _process(delta):
	# camera shake
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	
	camera_3d.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	camera_3d.rotation_degrees.y = initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)
	camera_3d.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)

func add_trauma(trauma_amount : float):
	trauma = clamp(trauma + trauma_amount, 0.0, 2.0)
	GameManager.player.blink()
	GameManager.player.play_breathing()
	GameManager.player.play_beep()

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(_seed : int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)


func change_looking_direction_based_on_mouse_position(mouse_position : Vector2) -> void:
	var dir = find_dir_based_on_mouse_position(mouse_position)
	set_dir_rotation(dir)

func find_dir_based_on_mouse_position(mouse_position : Vector2) -> dir:
	if abs(mouse_position.y) > abs(mouse_position.x):
		if mouse_position.y < 0:
			return dir.DOWN
		else:
			return dir.UP
	else: 
		if mouse_position.x > 0:
			return dir.RIGHT
		else:
			return dir.LEFT
	

func move_to_middle() -> void:
	move_to(look_position.CENTER)

func set_dir_rotation(new_dir: dir) -> void:
	match current_look_pos:
		look_position.CENTER: 
			match new_dir:
				dir.LEFT: 
					move_to(look_position.LEFT)
				dir.RIGHT: 
					move_to(look_position.RIGHT)
				dir.UP: 
					move_to(look_position.UP)
				dir.DOWN: 
					move_to(look_position.DOWN)
		look_position.LEFT: 
			match new_dir:
				dir.RIGHT: 
					move_to(look_position.CENTER)
		look_position.RIGHT: 
			match new_dir:
				dir.LEFT: 
					move_to(look_position.CENTER)
		look_position.UP: 
			match new_dir:
				dir.DOWN: 
					move_to(look_position.CENTER)
		look_position.DOWN: 
			match new_dir:
				dir.UP: 
					move_to(look_position.CENTER)


func move_to(new_look_position : look_position):
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	match new_look_position:
		look_position.CENTER: 
			tween.tween_property(self, "rotation_degrees", Vector3(0,0,0),turn_time)
			current_look_pos = look_position.CENTER
		look_position.LEFT: 
			tween.tween_property(self, "rotation_degrees", Vector3(0,max_angle,0),turn_time)
			current_look_pos = look_position.LEFT
		look_position.RIGHT: 
			tween.tween_property(self, "rotation_degrees", Vector3(0,-max_angle,0),turn_time)
			current_look_pos = look_position.RIGHT
		look_position.UP: 
			tween.tween_property(self, "rotation_degrees", Vector3(max_angle,0,0),turn_time)
			current_look_pos = look_position.UP
		look_position.DOWN: 
			tween.tween_property(self, "rotation_degrees", Vector3(-max_angle,0,0),turn_time)
			current_look_pos = look_position.DOWN
