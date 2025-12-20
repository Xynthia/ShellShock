class_name Player
extends CharacterBody3D

@onready var camera_pivot: Area3D = $CameraPivot

var do_this_once : bool = true;
var screen_relative : Vector2
var lastFrame : float
var lastMouseMove : float
var camera_move_timer : float
var camera_move_time : float

@export_subgroup("Mouse settings")
@export_range(1, 100, 1) var mouse_sensitivity: int = 50


func _enter_tree() -> void:
	GameManager.player = self

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_use_accumulated_input(false)

func _physics_process(delta: float) -> void:
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
