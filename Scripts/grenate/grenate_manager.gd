class_name GrenadeManager
extends Node3D

@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D

const GRENADE_CLASS = preload("res://Scenes/grenate.tscn")

var grenades : Array[Grenade]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.grenade_manager = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_grenade() -> void:
	var grenade : Grenade = GRENADE_CLASS.instantiate()
	grenades.push_back(grenade)
	add_child(grenade)
