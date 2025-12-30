class_name ArtilleryManager
extends Node3D

const ARTILLERY_CLASS = preload("uid://dempxvg1xn4nq")

var artillerys : Array[Array]

var amount_artillerys : float = 3

var amount_arti : float = 2

var rng = RandomNumberGenerator.new()
var artillery_pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.artillery_manager = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_artillery() -> void:
	var arty_barrage_pos : Node3D = Node3D.new()
	add_child(arty_barrage_pos)
	var arti_array : Array[Artillery]
	for amount in amount_arti:
		var artillery : Artillery = ARTILLERY_CLASS.instantiate()
		arti_array.push_back(artillery)
		arty_barrage_pos.add_child(artillery)
		set_position_artillery(artillery)
		await get_tree().create_timer(1).timeout
	
	arty_barrage_pos.position = set_position_artillery_barage()
	artillerys.push_back(arti_array)
	

func set_position_artillery_barage() -> Vector3:
	var half_x = GameManager.arty_danger_zone.x / 2
	var min_x = -half_x
	var max_x = half_x
	
	var half_z = GameManager.arty_danger_zone.z / 2
	var min_z = -half_z
	var max_z = half_z
	var random_x : float = randf_range(min_x, max_x)
	var random_z : float = randf_range(min_z, max_z)
	var y_to_the_ground : float = 0
	
	artillery_pos = Vector3(random_x, y_to_the_ground, random_z)
	
	return artillery_pos

func set_position_artillery(artillery : Artillery) -> void:
	var min_x = 0
	var max_x = 10
	var min_z = 0
	var max_z = 10
	var y_to_the_ground : float = 0
	
	var random_x : float = randf_range(min_x, max_x)
	var random_z : float = randf_range(min_z, max_z)
	
	artillery_pos = Vector3(random_x, y_to_the_ground, random_z)
	
	artillery.global_position = artillery_pos
