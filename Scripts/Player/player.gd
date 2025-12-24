class_name Player
extends CharacterBody3D

var id : int

@export_subgroup("Mouse settings")
@export_range(1, 100, 1) var mouse_sensitivity: int = 50

@onready var camera_pivot: Area3D = $CameraPivot
@onready var look_at_before_turn: Node3D = $LookAtBeforeTurn


var do_this_once_per_change : bool = true;
var screen_relative : Vector2
var lastFrame : float
var lastMouseMove : float
var camera_move_timer : float
var camera_move_time : float


var current_walk_point : VisibleOnScreenNotifier3D
var last_walk_point : VisibleOnScreenNotifier3D
var looking_at_walk_point : VisibleOnScreenNotifier3D

enum look_dir_3 {LEFT, MIDDLE, RIGHT}
enum look_dir_2 {LEFT, RIGHT}

var time_to_move : float = 0.5
var time_to_turn : float = 0.5

var do_this_once : bool = true

func _init() -> void:
	id = 1

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	

func _physics_process(delta: float) -> void:
	if do_this_once == true:
		set_new_position(current_walk_point)
		do_this_once = false
	
	looking_at_walk_point = get_looking_at_walk_point()
	
	if looking_at_walk_point && looking_at_walk_point != current_walk_point && Input.is_action_just_pressed("MoveFoward"):
		set_new_position(looking_at_walk_point)
	
	
	if Input.is_action_just_pressed("TurnLeft"):
		turn_to_walk_point(look_dir_2.LEFT)
	
	if Input.is_action_just_pressed("TurnRight"):
		turn_to_walk_point(look_dir_2.RIGHT)
	
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
			do_this_once_per_change = true
	
	lastFrame += delta
	
	if screen_relative != Vector2.ZERO && do_this_once_per_change:
		camera_pivot.change_looking_direction_based_on_mouse_position(screen_relative)
		do_this_once_per_change = false

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
	#if skipping a position check walkinpoints array
	last_walk_point = current_walk_point
	current_walk_point = new_position
	var status = move_to(new_position.position)
	if status == true:
		turn_to_walk_point_once_moved()


func get_looking_at_walk_point() -> VisibleOnScreenNotifier3D:
	var walk_points_next_to_current_walk_point : Array = GameManager.walking_points.check_points_next_to_current_point(current_walk_point)
	
	for walk_point : VisibleOnScreenNotifier3D in walk_points_next_to_current_walk_point:
		if walk_point.is_on_screen():
			return walk_point
	
	return null

func turn_to_walk_point(direction: int) -> void:
	var walk_points_next_to_current_walk_point : Array = GameManager.walking_points.check_points_next_to_current_point(current_walk_point)
	
	
	if walk_points_next_to_current_walk_point.size() == 3:
		var current_look_dir : look_dir_3
		
		if direction == look_dir_2.RIGHT:
			direction = look_dir_3.RIGHT
		elif direction == look_dir_2.LEFT:
			direction = look_dir_3.LEFT
		
		for walk_point : VisibleOnScreenNotifier3D in walk_points_next_to_current_walk_point:
			if looking_at_walk_point == walk_point:
				current_look_dir = walk_points_next_to_current_walk_point.find(walk_point, 0)
		
		match current_look_dir:
			look_dir_3.LEFT:
				if direction == look_dir_3.RIGHT:
					look_to(walk_points_next_to_current_walk_point[look_dir_3.MIDDLE].position)
			look_dir_3.MIDDLE:
				if direction == look_dir_3.LEFT:
					look_to(walk_points_next_to_current_walk_point[look_dir_3.LEFT].position)
				else:
					look_to(walk_points_next_to_current_walk_point[look_dir_3.RIGHT].position)
			look_dir_3.RIGHT:
				if direction == look_dir_3.LEFT:
					look_to(walk_points_next_to_current_walk_point[look_dir_3.MIDDLE].position)
	else:
		var current_look_dir : look_dir_2
		
		for walk_point : VisibleOnScreenNotifier3D in walk_points_next_to_current_walk_point:
			if looking_at_walk_point == walk_point:
				var position = walk_points_next_to_current_walk_point.find(walk_point, 0)
				if position == 1:
					current_look_dir = look_dir_2.RIGHT
				else:
					current_look_dir = look_dir_2.LEFT
	
		match current_look_dir:
			look_dir_2.LEFT:
				if direction == look_dir_2.RIGHT:
						look_to(walk_points_next_to_current_walk_point[look_dir_2.RIGHT].global_position)
			look_dir_2.RIGHT:
				if direction == look_dir_2.LEFT:
						look_to(walk_points_next_to_current_walk_point[look_dir_2.LEFT].global_position)

func turn_to_walk_point_once_moved() -> void:
	var points_next_to_current_point : Array = GameManager.walking_points.check_points_next_to_current_point(current_walk_point)
	
	for walk_point : VisibleOnScreenNotifier3D in points_next_to_current_point:
		if walk_point != last_walk_point:
			look_to(walk_point.position)


func move_to(new_position : Vector3) -> bool:
	new_position.y = self.position.y
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	tween.tween_property(self, "position",  new_position, time_to_move)
	
	return tween.is_running()


func look_to(new_position : Vector3) -> void:
	var direction = (new_position - global_position).normalized()
	
	var angle = atan2(direction.x, direction.z) + PI
	
	#rotation.y = angle
	var new_rotation = rotation
	new_rotation.y = angle
	
	
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	tween.tween_property(self, "rotation", new_rotation, time_to_turn)
	
	
