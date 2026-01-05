#class_name WalkingPoints
extends Node3D


@onready var walking_point_1: VisibleOnScreenNotifier3D = $WalkingPoint1
@onready var walking_point_2: VisibleOnScreenNotifier3D = $WalkingPoint2
@onready var walking_point_3: VisibleOnScreenNotifier3D = $WalkingPoint3
@onready var walking_point_4: VisibleOnScreenNotifier3D = $WalkingPoint4
@onready var walking_point_5: VisibleOnScreenNotifier3D = $WalkingPoint5
@onready var walking_point_6: VisibleOnScreenNotifier3D = $WalkingPoint6

@onready var starting_point: VisibleOnScreenNotifier3D = walking_point_1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#GameManager.walking_points = self
	#GameManager.player.current_walk_point = starting_point
	pass

func check_points_next_to_current_point(current_point : VisibleOnScreenNotifier3D) -> Array:
	var points_next_to_current_point : Array[VisibleOnScreenNotifier3D]
	
	# points next to current point, in order of left, middle, right if 3. otherwise , left and right
	match current_point:
		walking_point_1:
			points_next_to_current_point.push_back(walking_point_5)
			points_next_to_current_point.push_back(walking_point_2)
			points_next_to_current_point.push_back(walking_point_4)
		walking_point_2:
			points_next_to_current_point.push_back(walking_point_3)
			points_next_to_current_point.push_back(walking_point_1)
			points_next_to_current_point.push_back(walking_point_6)
		walking_point_3:
			points_next_to_current_point.push_back(walking_point_4)
			points_next_to_current_point.push_back(walking_point_2)
		walking_point_4:
			points_next_to_current_point.push_back(walking_point_1)
			points_next_to_current_point.push_back(walking_point_3)
		walking_point_5:
			points_next_to_current_point.push_back(walking_point_6)
			points_next_to_current_point.push_back(walking_point_1)
		walking_point_6:
			points_next_to_current_point.push_back(walking_point_2)
			points_next_to_current_point.push_back(walking_point_5)
	
	return points_next_to_current_point
