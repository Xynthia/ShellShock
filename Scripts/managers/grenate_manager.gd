class_name GrenadeManager
extends Node3D

@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D

@onready var area_3d: Area3D = $Area3D
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D


const GRENADE_CLASS = preload("uid://bedtrjbqukbwj")


var grenades : Array[Grenade]
var max_amount: int = 3

var rng = RandomNumberGenerator.new()
var grenade_pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.grenade_manager = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_grenade() -> void:
	if grenades.size() < max_amount:
		var grenade : Grenade = GRENADE_CLASS.instantiate()
		
		grenades.push_back(grenade)
		add_child(grenade)
		set_position_grenade(grenade)

func set_position_grenade(grenade : Grenade) -> void:
	var half_x = GameManager.grenade_danger_zone.x / 2
	var min_x = -half_x
	var max_x = half_x
	
	var half_z = GameManager.grenade_danger_zone.z / 2
	var min_z = -half_z
	var max_z = half_z
	var random_x : float = randf_range(min_x, max_x)
	var random_z : float = randf_range(min_z, max_z)
	var y_to_the_ground : float = 0
	
	grenade_pos = Vector3(random_x, y_to_the_ground, random_z)
	
	grenade.global_position = grenade_pos
