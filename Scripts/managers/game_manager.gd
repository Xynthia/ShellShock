extends Node

@export var player : Player
const PLAYER_CLASS = preload("uid://dd08kv410jg6r")

var mouse_sensitivity : float = 50

@export var grenade_manager : GrenadeManager
@export var artillery_manager : ArtilleryManager
@export var shot_manager : ShotManager

@export var walking_points : WalkingPoints

@export var arty_danger_zone : Vector3 = Vector3(30, 0.1, 30)
@export var grenade_danger_zone : Vector3 = Vector3(30, 0.1, 30)
@export var shot_danger_zone : Vector3 = Vector3(30, 0.1, 30)

const UI = preload("uid://eqq6woj0eqcg")
var ui : UIManager

const MAIN_MENU_LEVEL = preload("uid://bwh8r27jw7w6l")
var main_menu_level : Node3D

var started_main_menu : bool = false

var main_menu_environment : WorldEnvironment

var grenade_time_main_menu : Array[float] = [0.5, 15] 
var artillery_time_main_menu : Array[float] = [0.5, 30] 
var shot_time_main_menu : Array[float] = [0.5, 21] 

const LEVEL = preload("uid://n8usaw7wote5")
var level : Node3D

var game_environment : WorldEnvironment

var started_game : bool = false

var grenade_timer : float = 0
var artillery_timer : float = 0
var shot_timer : float = 0

var rng = RandomNumberGenerator.new()

var grenade_time : Array[float] = [0.5, 5] 
var artillery_time : Array[float] = [0.5, 10] 
var shot_time : Array[float] = [0.5, 7] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_main_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started_main_menu:
		if grenade_timer <= 0:
			grenade_timer = rng.randf_range(grenade_time_main_menu[0], grenade_time_main_menu[1])
			grenade_manager.spawn_grenade()
		
		if artillery_timer <= 0:
			artillery_timer = rng.randf_range(artillery_time_main_menu[0], artillery_time_main_menu[1])
			artillery_manager.spawn_artillery()
		
		if shot_timer <= 0:
			shot_timer = rng.randf_range(shot_time_main_menu[0], shot_time_main_menu[1])
			shot_manager.spawn_shot()
		
		grenade_timer -= delta
		artillery_timer -= delta
		shot_timer -= delta
	

	
	if started_game && get_tree().paused == false:
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
		

func start_main_menu() -> void:
	ui = UI.instantiate()
	get_tree().get_first_node_in_group("Scene").add_child(ui)
	
	add_main_menu_level()
	
	main_menu_environment = get_main_menu_environment()
	started_main_menu = true

func add_main_menu_level()-> void:
	main_menu_level = MAIN_MENU_LEVEL.instantiate()
	ui.add_child(main_menu_level)

func start_game() -> void:
	var new_player = PLAYER_CLASS.instantiate()
	player = new_player
	player.mouse_sensitivity = mouse_sensitivity
	
	get_tree().get_first_node_in_group("Scene").add_child(player)
	
	level = LEVEL.instantiate()
	get_tree().get_first_node_in_group("Scene").add_child(level)
	
	game_environment = get_game_environment()
	
	if game_environment != null:
		game_environment.environment.adjustment_brightness = main_menu_environment.environment.adjustment_brightness
		game_environment.environment.adjustment_contrast = main_menu_environment.environment.adjustment_contrast
	
	ui.panel.visible = false
	main_menu_level.queue_free()
	
	started_game = true



func get_main_menu_environment() -> WorldEnvironment:
	for node in main_menu_level.get_children():
		if node.is_in_group("Node_Environment"):
			for child in node.get_children():
				if child.is_in_group("Environment"):
					return child
	return null

func get_game_environment() -> WorldEnvironment:
	for game_level in level.get_children():
		if game_level.is_in_group("Node_Environment"):
			for child in game_level.get_children():
				if child.is_in_group("Environment"):
					return child
	return null
