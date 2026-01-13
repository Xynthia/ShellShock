class_name Player
extends CharacterBody3D

var id : int

@export_subgroup("Mouse settings")
@export_range(1, 100, 1) var mouse_sensitivity: int = 50

@onready var camera_pivot: Area3D = $pauseble/CameraPivot
@onready var look_at_before_turn: Node3D = $pauseble/LookAtBeforeTurn


@onready var bg_sound: AudioStreamPlayer3D = $pauseble/BGSound
@onready var sfx: AudioStreamPlayer3D = $pauseble/SFX
@onready var va: AudioStreamPlayer3D = $pauseble/VA

@onready var animation_player: AnimationPlayer = $pauseble/eyelids/AnimationPlayer



const NIGHT_TIME_WIND_WHISTLING = preload("uid://bwn5r0eekogkq")
const OUT_OF_BREATH_HEAVY_MALE = preload("uid://cfpfpg1s06gni")
const TINNITUS = preload("uid://cwtpeduhorxbe")

const TURN_BACK_0 = preload("uid://igunpplmegpw")
const TURN_BACK_1 = preload("uid://ge6f6n5hwvp4")
const TURN_BACK_2 = preload("uid://ctvlohju74u1p")
const TURN_BACK_3 = preload("uid://b37k6evqr1ehi")

var voice_lines_return_to_trenches : Array = [TURN_BACK_0, TURN_BACK_1, TURN_BACK_2, TURN_BACK_3]

var middle : Array[float] = [-37.5, 37.5]
var right : Array[float] = [37.5, 180]
var left : Array[float] = [-37.5, -180]

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

const SPEED : float = 13
var time_to_turn : float = 0.5

var do_this_once : bool = true
var dead_end_check : bool = false

var move_tween : Tween
var turn_tween : Tween 
var sound_tween : Tween 

var turn_once : bool = true
var for_first_spawn : bool = true

func _init() -> void:
	id = 1

func _ready() -> void:
	play_BG()

func _physics_process(delta: float) -> void:
	if position != current_walk_point.position && do_this_once:
		set_new_position(current_walk_point)
		do_this_once = false
	
	
	if looking_at_walk_point && looking_at_walk_point != current_walk_point && check_walkpoint_dead_end() == false && Input.is_action_just_pressed("MoveFoward"):
		set_new_position(looking_at_walk_point)
	elif looking_at_walk_point && looking_at_walk_point == last_walk_point && check_walkpoint_dead_end() == true && dead_end_check == false && Input.is_action_just_pressed("MoveFoward"):
		set_new_position(looking_at_walk_point)
	
	
	
	if Input.is_action_just_pressed("TurnLeft"):
		camera_pivot.move_to_middle()
		turn_to_walk_point(look_dir_3.RIGHT)
	if Input.is_action_just_pressed("TurnRight"):
		camera_pivot.move_to_middle()
		turn_to_walk_point(look_dir_3.LEFT)
	
	if get_tree().paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("pause"):
		GameManager.ui.pause_menu()
	
	
	
	
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


func blink():
	animation_player.play("blink")



func set_new_position(new_position: VisibleOnScreenNotifier3D) -> void:
	#if skipping a position check walkinpoints array
	last_walk_point = current_walk_point
	current_walk_point = new_position
	
	camera_pivot.move_to_middle()
	move_to(new_position)
	

func turn_to_walk_point(direction: look_dir_3) -> void:
	var walk_points_next_to_current_walk_point : Array = GameManager.walking_points.check_points_next_to_current_point(current_walk_point)
	
	var walking_points_directions : Array[look_dir_3]
	var walking_points_closest : Array[VisibleOnScreenNotifier3D]
	var next_look_at_walking_point : VisibleOnScreenNotifier3D
	var closest_walking_point_left : VisibleOnScreenNotifier3D
	var closest_walking_point_right : VisibleOnScreenNotifier3D
	
	
	var last_degree_difference : float = 360
	
	if walk_points_next_to_current_walk_point.size() > 1:
		for walk_point in walk_points_next_to_current_walk_point:
			var look_at_pos : CollisionShape3D = CollisionShape3D.new()
			
			look_at_pos.look_at_from_position(current_walk_point.global_position ,walk_point.global_position, up_direction, true)
			
			var vec1 = self.rotation
			var vec2 = look_at_pos.rotation
			
			var difference_in_degrees = angle_difference(vec1.y, vec2.y)
			var degrees = rad_to_deg(difference_in_degrees)
			
			degrees = fmod(degrees + 180.0, 360.0) - 180.0
			
			if degrees >= middle[0] && degrees <=  middle[1]:
				walking_points_directions.push_back(look_dir_3.MIDDLE)
			elif degrees >=  right[0] && degrees <=  right[1]:
				walking_points_directions.push_back(look_dir_3.RIGHT)
			elif degrees >=  left[1] && degrees <= left[0]:
				walking_points_directions.push_back(look_dir_3.LEFT)
			
			
			if abs(degrees) < abs(last_degree_difference):
				walking_points_closest.push_front(walk_point)
				last_degree_difference = degrees
			elif last_degree_difference == null:
				last_degree_difference = degrees
			else:
				walking_points_closest.push_back(walk_point)
		
		for walking_point in walking_points_closest:
			var direction_walking_point_id: int = walk_points_next_to_current_walk_point.find(walking_point)
			var direction_walking_point : look_dir_3 = walking_points_directions[direction_walking_point_id]
			
			if !closest_walking_point_left && direction_walking_point == look_dir_3.LEFT:
				closest_walking_point_left = walking_point
			if !closest_walking_point_right && direction_walking_point == look_dir_3.RIGHT:
				closest_walking_point_right = walking_point
			
		
		if direction == look_dir_3.LEFT:
			for walking_point in walking_points_directions:
				if walking_point == look_dir_3.LEFT && closest_walking_point_left:
					next_look_at_walking_point = closest_walking_point_left
		if direction == look_dir_3.RIGHT:
			for walking_point in walking_points_directions:
				if walking_point == look_dir_3.RIGHT && closest_walking_point_right:
					next_look_at_walking_point = closest_walking_point_right
		
	else:
		next_look_at_walking_point = walk_points_next_to_current_walk_point[0]
		
	if next_look_at_walking_point:
		look_to(next_look_at_walking_point)
	

func check_walkpoint_dead_end() -> bool:
	var walking_points = GameManager.walking_points.check_points_next_to_current_point(current_walk_point)
	
	if walking_points != null && walking_points.size() == 1:
		return true
	
	return false

func turn_to_walk_point_once_moved() -> void:
	var points_next_to_current_point : Array = GameManager.walking_points.check_points_next_to_current_point(current_walk_point)
	
	for walk_point : VisibleOnScreenNotifier3D in points_next_to_current_point:
		if turn_once && walk_point != last_walk_point && looking_at_walk_point == current_walk_point || looking_at_walk_point == null:
			look_to(walk_point)
		

func move_to(new_walk_point : VisibleOnScreenNotifier3D) -> void:
	move_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	new_walk_point.global_position.y = self.position.y
	
	var distance : float = self.position.distance_to(new_walk_point.position)
	
	var time : float = distance / SPEED
	
	print(distance, " ", SPEED, " ", time)
	
	move_tween.tween_property(self, "position",  new_walk_point.global_position, time)
	
	move_tween.finished.connect(on_move_tween_finished)

func on_move_tween_finished() -> void:
	if check_walkpoint_dead_end() == true:
		dead_end_check = true
		var new_looking_at_walk_point = GameManager.walking_points.check_look_at_point(current_walk_point)
		if new_looking_at_walk_point != null:
			look_to(new_looking_at_walk_point)
	else:
		turn_to_walk_point_once_moved()

func look_to(new_walk_point : VisibleOnScreenNotifier3D) -> void:
	turn_once = false
	turn_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	var look_at_pos : CollisionShape3D = CollisionShape3D.new()
	
	look_at_pos.look_at_from_position(global_position ,new_walk_point.global_position, up_direction, true)
	
	var vec1 = self.rotation
	var vec2 = look_at_pos.rotation
	
	var difference_in_degrees = angle_difference(vec1.y, vec2.y)
	
	var new_rotation_degrees :Vector3
	var degrees = rad_to_deg(difference_in_degrees)
	
	new_rotation_degrees.y = rad_to_deg(vec1.y) + degrees 
	  
	turn_tween.tween_property(self, "rotation_degrees", new_rotation_degrees , time_to_turn)
	
	turn_tween.finished.connect(on_turn_tween_finished.bind(new_walk_point))


func on_turn_tween_finished(walk_point) ->void:
	turn_once = true
	looking_at_walk_point = walk_point
	
	if check_walkpoint_dead_end() == true && dead_end_check == true:
		play_return_to_trenches()
		
		dead_end_check = false

func play_BG() -> void:
	bg_sound.stream = NIGHT_TIME_WIND_WHISTLING
	
	bg_sound.play()


func play_return_to_trenches() -> void:
	var random_line_id = randi_range(0, voice_lines_return_to_trenches.size() - 1)
	var voice_line : AudioStream = voice_lines_return_to_trenches[random_line_id]
	
	va.stream = voice_line
	va.play()



func play_beep() -> void:
	sfx.stream = TINNITUS
	
	sfx.play()
	var lowest_db = -80

	var sound_duration = 1
	
	sound_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	sound_tween.tween_property(sfx, "volume_db", lowest_db, sound_duration)
