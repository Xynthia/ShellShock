extends CharacterBody3D

@onready var camera_pivot: Area3D = $CameraPivot

var viewport_quarter_x : float
var viewport_left_quarter : float
var viewport_right_quarter : float

var viewport_quarter_y : float
var viewport_up_quarter : float
var viewport_down_quarter : float

func _ready() -> void:
	Input.MOUSE_MODE_CONFINED
	viewport_quarter_x = get_viewport().get_visible_rect().size.x / 4
	viewport_quarter_y = get_viewport().get_visible_rect().size.y / 4
	
	viewport_left_quarter = viewport_quarter_x
	viewport_right_quarter = get_viewport().get_visible_rect().size.x - viewport_quarter_x
	
	viewport_up_quarter = viewport_quarter_y
	viewport_down_quarter = get_viewport().get_visible_rect().size.y - viewport_quarter_y

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	



func _input(event: InputEvent) -> void:
	
	# check which side mouse is the camera movement to that side
	if event is InputEventMouseMotion:
		camera_pivot.change_looking_direction_based_on_mouse_position(event.position)
