class_name Player
extends CharacterBody3D

var id : int

@export_subgroup("Mouse settings")
@export_range(1, 100, 1) var mouse_sensitivity: int = 50

@onready var camera_pivot: Area3D = $CameraPivot

var do_this_once : bool = true;
var screen_relative : Vector2
var lastFrame : float
var lastMouseMove : float
var camera_move_timer : float
var camera_move_time : float


var current_walk_point : VisibleOnScreenNotifier3D
var last_walk_point : VisibleOnScreenNotifier3D
var looking_at_walk_point : VisibleOnScreenNotifier3D

enum look_dir {LEFT, MIDDLE, RIGHT}

func _init() -> void:
	id = 1

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	

func _physics_process(delta: float) -> void:
	if current_walk_point != null:
		set_new_position(current_walk_point)
	
	looking_at_walk_point = get_looking_at_walk_point()
	
	if looking_at_walk_point && looking_at_walk_point != current_walk_point && Input.is_action_just_pressed("MoveFoward"):
		set_new_position(looking_at_walk_point)
	
	
	if looking_at_walk_point == null:
		turn_to_walk_point(look_dir.MIDDLE)
	
	if looking_at_walk_point == last_walk_point:
		turn_to_walk_point(look_dir.RIGHT)
	#else:
		#turn_to_walk_point(look_dir.LEFT)
	
	if Input.is_action_just_pressed("TurnLeft"):
		turn_to_walk_point(look_dir.LEFT)
	
	if Input.is_action_just_pressed("TurnRight"):
		turn_to_walk_point(look_dir.RIGHT)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	# camera movement
	if lastMouseMove < lastFrame:
		screen_relative = Vector2.ZERO
		camera_move_timer += delta
		if camera_move_timer > camera_move_time:
			camera_move_timer = 0
			do_this_once = true
	
	lastFrame += delta
	
	if screen_relative != Vector2.ZERO && do_this_once:
		camera_pivot.change_looking_direction_based_on_mouse_position(screen_relative)
		do_this_once = false

func _input(event: InputEvent) -> void:
	# check which side mouse is the camera movement to that side
	if event is InputEventMouseMotion:
		if abs(event.screen_relative.x) > 25 or abs(event.screen_relative.y) > 25:
			var degrees_per_unit: float = 0.001
			screen_relative = event.screen_relative
			
			lastMouseMove = lastFrame
			screen_relative *= mouse_sensitivity
			screen_relative *= degrees_per_unit

func set_new_position(new_position: VisibleOnScreenNotifier3D) -> void:
	last_walk_point = current_walk_point
	current_walk_point = new_position
	position = new_position.position


func get_looking_at_walk_point() -> VisibleOnScreenNotifier3D:
	var points_next_to_current_point : Array = GameManager.walking_points.check_points_next_to_current_point(current_walk_point)
	
	for walk_point : VisibleOnScreenNotifier3D in points_next_to_current_point:
		if walk_point.is_on_screen():
			return walk_point
	
	return null

func turn_to_walk_point(direction: int) -> void:
	var points_next_to_current_point : Array = GameManager.walking_points.check_points_next_to_current_point(current_walk_point)
	var first_point_next_to_current_point : VisibleOnScreenNotifier3D
	
	# doesnt work because the left or rigth side depends on how the player walks but should be on how the player is facing.
	
	
	
	
	if direction == look_dir.MIDDLE:
		if points_next_to_current_point.size() <= 2:
			pass
		else:
			first_point_next_to_current_point = points_next_to_current_point[1]
	elif direction == look_dir.LEFT:
		if points_next_to_current_point.size() <= 2:
			first_point_next_to_current_point = points_next_to_current_point[0]
		else:
			first_point_next_to_current_point = points_next_to_current_point[0]
	elif direction == look_dir.RIGHT:
		if points_next_to_current_point.size() <= 2:
			first_point_next_to_current_point = points_next_to_current_point[1]
		else:
			first_point_next_to_current_point = points_next_to_current_point[2]
	
	look_at(first_point_next_to_current_point.position, up_direction)
