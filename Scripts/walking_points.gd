class_name WalkingPoints
extends Node3D

@onready var walking_point_1: VisibleOnScreenNotifier3D = $WalkingPoint1
@onready var walking_point_2: VisibleOnScreenNotifier3D = $WalkingPoint2
@onready var walking_point_3: VisibleOnScreenNotifier3D = $WalkingPoint3
@onready var walking_point_4: VisibleOnScreenNotifier3D = $WalkingPoint4



@onready var starting_point: VisibleOnScreenNotifier3D = walking_point_1




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.walking_points = self
	GameManager.player.current_walk_point = starting_point
	


func check_points_next_to_current_point(current_point : VisibleOnScreenNotifier3D) -> Array:
	var points_next_to_current_point : Array[VisibleOnScreenNotifier3D]
	
	# points at the top will be the next looking at point for player. if you want a specific point to show first over another then that has to be on the top.
	match current_point:
		walking_point_1:
			points_next_to_current_point.push_back(walking_point_2)
			points_next_to_current_point.push_back(walking_point_4)
		walking_point_2:
			points_next_to_current_point.push_back(walking_point_3)
			points_next_to_current_point.push_back(walking_point_1)
		walking_point_3:
			points_next_to_current_point.push_back(walking_point_4)
			points_next_to_current_point.push_back(walking_point_2)
		walking_point_4:
			points_next_to_current_point.push_back(walking_point_1)
			points_next_to_current_point.push_back(walking_point_3)
	
	return points_next_to_current_point
