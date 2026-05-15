class_name PlayerMovement
extends Node

enum look_dir_3 {LEFT, MIDDLE, RIGHT}
enum look_dir_2 {LEFT, RIGHT}
enum state {WAIT, MOVE, TURN}

var move_tween : Tween
var turn_tween : Tween 

var current_walk_point : VisibleOnScreenNotifier3D
var last_walk_point : VisibleOnScreenNotifier3D
var looking_at_walk_point : VisibleOnScreenNotifier3D

var current_state : state

var trun_tween_timer : float 

var middle : Array[float] = [-37.5, 37.5]
var right : Array[float] = [37.5, 180]
var left : Array[float] = [-37.5, -180]

var time_to_turn : float = 0.5

var do_this_once : bool = true

var turn_once : bool = true
var able_to_move : bool = true

var dead_end_check : bool = false

var moved_foward : bool = false
var turned_right : bool = false
var turned_left : bool = false


func _physics_process(delta: float) -> void:
	if GameManager.started_game && current_walk_point && GameManager.player.position != current_walk_point.position && do_this_once:
		set_new_position(current_walk_point)
		do_this_once = false
	
	if looking_at_walk_point && looking_at_walk_point != current_walk_point && check_walkpoint_dead_end() == false && Input.is_action_just_pressed("MoveFoward") && current_state == state.WAIT:
		current_state = state.MOVE
		if GameManager.events_manager.controls_a_d && GameManager.events_manager.finished_fade_in:
			moved_foward = true
		set_new_position(looking_at_walk_point)
	elif looking_at_walk_point && looking_at_walk_point == last_walk_point && check_walkpoint_dead_end() == true && dead_end_check == false && Input.is_action_just_pressed("MoveFoward") && current_state == state.WAIT:
		current_state = state.MOVE
		if GameManager.events_manager.controls_a_d  && GameManager.events_manager.finished_fade_in:
			moved_foward = true
		set_new_position(looking_at_walk_point)
	
	if current_state == state.TURN:
		trun_tween_timer = trun_tween_timer + delta
		if turn_tween.get_total_elapsed_time() >= time_to_turn:
			current_state = state.WAIT
	
	if Input.is_action_just_pressed("TurnLeft") && current_state == state.WAIT:
		current_state = state.TURN
		if GameManager.events_manager.started_tutorial && GameManager.events_manager.finished_fade_in:
			turned_left = true
		GameManager.player.camera_pivot.move_to_middle()
		turn_to_walk_point(look_dir_3.RIGHT)
	elif Input.is_action_just_pressed("TurnRight") && current_state == state.WAIT:
		current_state = state.TURN
		if GameManager.events_manager.started_tutorial && GameManager.events_manager.finished_fade_in:
			turned_right = true
		GameManager.player.camera_pivot.move_to_middle()
		turn_to_walk_point(look_dir_3.LEFT)

func set_new_position(new_position: VisibleOnScreenNotifier3D) -> void:
	#if skipping a position check walkinpoints array
	last_walk_point = current_walk_point
	current_walk_point = new_position
	
	GameManager.player.camera_pivot.move_to_middle()
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
			
			look_at_pos.look_at_from_position(current_walk_point.global_position ,walk_point.global_position, GameManager.player.up_direction, true)
			
			var vec1 = GameManager.player.rotation
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
	able_to_move = false
	move_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	new_walk_point.global_position.y = GameManager.player.position.y
	
	var distance : float = GameManager.player.position.distance_to(new_walk_point.position)
	
	var time : float = distance / GameManager.player.SPEED
	
	move_tween.tween_property(GameManager.player, "position",  new_walk_point.global_position, time)
	
	move_tween.finished.connect(on_move_tween_finished)

func on_move_tween_finished() -> void:
	if check_walkpoint_dead_end() == true:
		dead_end_check = true
		var new_looking_at_walk_point = GameManager.walking_points.check_look_at_point(current_walk_point)
		if new_looking_at_walk_point != null:
			current_state = state.TURN
			look_to(new_looking_at_walk_point)
	else:
		turn_to_walk_point_once_moved()
	
	if GameManager.started_death:
		GameManager.reset_position_after_death_done = true
	
	trun_tween_timer = 0
	current_state = state.WAIT

func look_to(new_walk_point : VisibleOnScreenNotifier3D) -> void:
	turn_once = false
	turn_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	var look_at_pos : CollisionShape3D = CollisionShape3D.new()
	
	look_at_pos.look_at_from_position(GameManager.player.global_position ,new_walk_point.global_position, GameManager.player.up_direction, true)
	
	var vec1 = GameManager.player.rotation
	var vec2 = look_at_pos.rotation
	
	var difference_in_degrees = angle_difference(vec1.y, vec2.y)
	
	var new_rotation_degrees :Vector3
	var degrees = rad_to_deg(difference_in_degrees)
	
	new_rotation_degrees.y = rad_to_deg(vec1.y) + degrees 
	  
	turn_tween.tween_property(GameManager.player, "rotation_degrees", new_rotation_degrees , time_to_turn)
	
	turn_tween.finished.connect(on_turn_tween_finished.bind(new_walk_point))

func on_turn_tween_finished(walk_point) ->void:
	if walk_point != null:
		turn_once = true
		looking_at_walk_point = walk_point
		current_state = state.WAIT
		
		if check_walkpoint_dead_end() == true && dead_end_check == true:
			GameManager.player.sound.play_return_to_trenches()
			
			dead_end_check = false
