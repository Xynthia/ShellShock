extends Area3D

@export var trauma_reduction_rate := 0

@export var max_x := 10.0
@export var max_y := 10.0
@export var max_z := 5.0

@export var noise : FastNoiseLite
@export var noise_speed := 50.0

var trauma := 0.0
var time := 0.0

@onready var camera_3d: Camera3D = $Camera3D

@onready var initial_rotation := camera_3d.rotation_degrees as Vector3

@onready var turn_timer: Timer = $"../TurnTimer"

var max_angle : float = 30
var zero_point : Vector2
var percentage_distance_x : float
var percentage_distance_y : float
var percentage_distance_zero_point : float = 50

enum dir {CENTER, LEFT, RIGHT, UP, DOWN}

var dir_rotation : Vector3 

var test : String = "test"

func _ready() -> void:
	zero_point = get_viewport().get_visible_rect().size / 2

func _process(delta):
	
	# camera shake
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	
	camera_3d.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	camera_3d.rotation_degrees.y = initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)
	camera_3d.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)

func add_trauma(trauma_amount : float):
	trauma = clamp(trauma + trauma_amount, 0.0, 1.0)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(_seed : int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)

func change_looking_direction_based_on_mouse_position(mouse_position : Vector2) -> void:
	var dir = find_dir_based_on_mouse_position(mouse_position)
	set_dir_rotation(dir)
	


func find_dir_based_on_mouse_position(mouse_position : Vector2) -> float:
	var distance_x : float = mouse_position.x - zero_point.x 
	var distance_y : float = mouse_position.y - zero_point.y
	
	percentage_distance_x = (100 / get_viewport().get_visible_rect().size.x ) * distance_x
	percentage_distance_y = (100 / get_viewport().get_visible_rect().size.y ) * distance_y
	
	if abs(percentage_distance_x) < (percentage_distance_zero_point / 2) and abs(percentage_distance_y) < (percentage_distance_zero_point / 2):
		return dir.CENTER
	else :
		if abs(percentage_distance_x) > abs(percentage_distance_y):
			if percentage_distance_x < 0:
				return dir.LEFT
			else:
				return dir.RIGHT
		else :
			if percentage_distance_y < 0:
				return dir.UP
			else:
				return dir.DOWN

func set_dir_rotation(new_dir: int) -> void:
	match new_dir:
		0: #center
			dir_rotation = Vector3(0, 0, 0)
		1: #left
			dir_rotation = Vector3(0, max_angle, 0)
		2: #right
			dir_rotation = Vector3(0, -max_angle, 0)
		3: #up
			dir_rotation = Vector3(max_angle, 0, 0)
		4: #down
			dir_rotation = Vector3(-max_angle, 0, 0)
	
	turn_timer.start()
