extends Node

@export var player : Player
const PLAYER_CLASS = preload("uid://dd08kv410jg6r")


@export var grenade_manager : GrenadeManager
@export var artillery_manager : ArtilleryManager
@export var shot_manager : ShotManager

@export var walking_points : WalkingPoints

@export var arty_danger_zone : Vector3 = Vector3(30, 0.1, 30)
@export var grenade_danger_zone : Vector3 = Vector3(30, 0.1, 30)
@export var shot_danger_zone : Vector3 = Vector3(30, 0.1, 30)

var started_game : bool = false

var grenade_timer : float = 0
var artillery_timer : float = 0
var shot_timer : float = 0

var rng = RandomNumberGenerator.new()

var grenade_time : Array[float] = [0.5, 10] 
var artillery_time : Array[float] = [0.5, 20] 
var shot_time : Array[float] = [0.5, 15] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started_game:
		if grenade_timer <= 0:
			grenade_timer = rng.randf_range(grenade_time[0], grenade_time[1])
			grenade_manager.spawn_grenade()
		
		if artillery_timer <= 0:
			artillery_timer = rng.randf_range(artillery_time[0], artillery_time[1])
			artillery_manager.spawn_artillery()
		
		if shot_timer <= 0:
			shot_timer = rng.randf_range(shot_time[0], shot_time[1])
			shot_manager.spawn_shot()
		
		grenade_timer -= delta
		artillery_timer -= delta
		shot_timer -= delta
		


func start_game() -> void:
	var new_player = PLAYER_CLASS.instantiate()
	player = new_player
	get_tree().get_first_node_in_group("Scene").add_child(player)
	started_game = true
