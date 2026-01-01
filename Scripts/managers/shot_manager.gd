class_name ShotManager
extends Node3D

const SHOT_CLASS = preload("uid://pirqdphslrxt")


var shots : Array[Shot]
var max_amount: int = 8

var rng = RandomNumberGenerator.new()
var shot_pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.shot_manager = self

func spawn_shot()-> void:
	if shots.size() < max_amount:
		var shot : Shot = SHOT_CLASS.instantiate()
		
		shots.push_back(shot)
		add_child(shot)
		set_position_shot(shot)


func set_position_shot(shot : Shot) -> void:
	var half_x = GameManager.shot_danger_zone.x / 2
	var min_x = -half_x
	var max_x = half_x
	
	var half_z = GameManager.shot_danger_zone.z / 2
	var min_z = -half_z
	var max_z = half_z
	var random_x : float = randf_range(min_x, max_x)
	var random_z : float = randf_range(min_z, max_z)
	var y_to_the_ground : float = 0
	
	shot_pos = Vector3(random_x, y_to_the_ground, random_z)
	
	shot.global_position = shot_pos
