class_name Player
extends CharacterBody3D

var id : int

@export_subgroup("Mouse settings")
@export_range(1, 100, 1) var mouse_sensitivity: int = 50

@onready var camera_pivot: CameraMovement = $pauseble/CameraPivot
@onready var look_at_before_turn: Node3D = $pauseble/LookAtBeforeTurn

@onready var animation_player: AnimationPlayer = $pauseble/eyelids/AnimationPlayer

@onready var animations : PlayerAnimations = $Animations
@onready var movement : PlayerMovement = $Movement
@onready var sound : PlayerSound = $Sound

var do_this_once_per_change : bool = true;
var screen_relative : Vector2
var lastFrame : float
var lastMouseMove : float
var camera_move_timer : float
var camera_move_time : float

const SPEED : float = 13

var able_to_turn : bool = true

var for_first_spawn : bool = true
var can_be_hit_for_end_scene : bool = false
var took_trauma : bool = false

var started_panic_attack : bool = false
var interaction_panic_attack : bool = false
var amount_interaction_panic_atttack : float = 1.0
var max_amount_interaction_panic_attack : float = 2.0
var min_amount_interaction_panic_attack : float = 0.0
var amount_interaction_added : float = 0.07
var amount_interaction_removed : float = 0.001
var starting_amount_interaction_panic_atttack : float = 1.0

var started_ending : bool = false
var amount_blink : int = 0

var pressed_escape : bool = false

func _init() -> void:
	id = 1

func _ready() -> void:
	sound.play_BG()

func _physics_process(delta: float) -> void:
	if GameManager.started_game && !GameManager.started_death:
		if get_tree().paused == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		if Input.is_action_just_pressed("pause"):
			if GameManager.events_manager.controls_mouse && GameManager.events_manager.finished_fade_in:
				pressed_escape = true
			GameManager.ui.pause_menu()
		
		if can_be_hit_for_end_scene == true && took_trauma == true:
			end_scene()
			can_be_hit_for_end_scene = false
		
		if interaction_panic_attack:
			if Input.is_action_just_pressed("Interact"):
				amount_interaction_panic_atttack += amount_interaction_added
			else:
				amount_interaction_panic_atttack -= amount_interaction_removed
			
			if amount_interaction_panic_atttack >= max_amount_interaction_panic_attack:
				get_out_panic_attack()
			if amount_interaction_panic_atttack <= min_amount_interaction_panic_attack:
				die()
		
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
		if abs(event.screen_relative.x) > 75 or abs(event.screen_relative.y) > 75:
			var degrees_per_unit: float = 0.001
			screen_relative = event.screen_relative
			
			lastMouseMove = lastFrame
			screen_relative *= mouse_sensitivity
			screen_relative *= degrees_per_unit

func trauma_response() -> void:
	if !started_panic_attack && !GameManager.started_death:
		animations.blink()
		sound.play_breathing()
		sound.play_beep()
		took_trauma = true

func panic_attack() -> void:
	started_panic_attack = true
	took_trauma = true
	sound.play_beep()
	fase_one_panic_attack()

func fase_one_panic_attack() -> void:
	animations.rapid_blur()

func fase_two_panic_attack() -> void:
	animations.stop_blur()
	animations.long_blur()
	
	fase_three_panic_attack()

func fase_three_panic_attack() -> void:
	animations.blink()
	sound.play_breathing()
	sound.play_heartbeat()
	interaction_panic_attack = true

func fase_four_panic_attack() -> void:
	sound.make_quiet = true
	animations.play_vignette()
	animations.stop_blur()

func get_out_panic_attack() -> void:
	started_panic_attack = false
	interaction_panic_attack = false
	amount_interaction_panic_atttack = starting_amount_interaction_panic_atttack
	animations.closed_eyes_done = false
	animations.stop_vignette()
	animations.stop_blur()
	animations.open_eyes()
	sound.stop_heartbeat()
	sound.return_sound = true

func die() -> void:
	GameManager.started_death = true
	interaction_panic_attack = false
	amount_interaction_panic_atttack = starting_amount_interaction_panic_atttack
	animations.stop_vignette()
	sound.stop_heartbeat()
	sound.complete_silence()
	animations.closed_eyes()
	
	animations.closed_eyes_done = false
	
	#move back to startpoint
	movement.current_walk_point = GameManager.walking_points.starting_point
	movement.set_new_position(movement.current_walk_point)


func end_scene() -> void:
	var i = 3
	
	started_ending = true
	for amount in i:
		animations.blink()
		amount_blink += 1
		
	GameManager.started_game = false
