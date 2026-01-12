class_name ArtilleryManager
extends Area3D

const ARTILLERY_CLASS = preload("uid://dempxvg1xn4nq")

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

@onready var collision_size : Vector3 = collision_shape_3d.shape.size

var artillerys : Array[Array]
var amount_artillerys : int = 2

var amount_arti : float = 2

var rng = RandomNumberGenerator.new()
var artillery_pos : Vector3

var barrage_sent = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.artillery_manager = self
	GameManager.arty_danger_zone = collision_size

func _physics_process(delta: float) -> void:
	
	# erasing barrage with all elements null
	for barrage in artillerys:
		if !is_instance_valid(barrage[0]) &&  !is_instance_valid(barrage[1]):
			GameManager.artillery_manager.artillerys.erase(barrage)

func spawn_artillery() -> void:
	if artillerys.size() < amount_artillerys && barrage_sent == true:
		barrage_sent = false
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
		barrage_sent = true
	

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
	
	artillery_pos = Vector3(random_x + position.x, y_to_the_ground, random_z + position.z)
	
	artillery.global_position = artillery_pos
