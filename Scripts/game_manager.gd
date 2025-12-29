extends Node

@export var player : Player
const PLAYER_CLASS = preload("res://Scenes/player.tscn")

@export var grenade_manager : GrenadeManager

@export var walking_points : WalkingPoints

@export var size_danger_zone : Vector3 = Vector3(30, 0.1, 30)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game() -> void:
	var new_player = PLAYER_CLASS.instantiate()
	player = new_player
	get_tree().get_first_node_in_group("Scene").add_child(player)
