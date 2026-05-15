class_name PlayerSound
extends Node

@onready var bg_sound: AudioStreamPlayer3D = $"../pauseble/BGSound"
@onready var sfx: AudioStreamPlayer3D = $"../pauseble/SFX"
@onready var breathing: AudioStreamPlayer3D = $"../pauseble/Breathing"
@onready var va: AudioStreamPlayer3D = $"../pauseble/VA"

@onready var bg_sound_bus_index = AudioServer.get_bus_index(bg_sound.bus)
@onready var sfx_bus_index = AudioServer.get_bus_index(sfx.bus)
@onready var explosions_bus_index = AudioServer.get_bus_index("Explosions")

@onready var highest_BG_DB =  AudioServer.get_bus_volume_db(bg_sound_bus_index)
@onready var highest_sfx_DB =  AudioServer.get_bus_volume_db(sfx_bus_index)
@onready var highest_explosions_DB =  AudioServer.get_bus_volume_db(explosions_bus_index)

@onready var curent_BG_DB = AudioServer.get_bus_volume_db(bg_sound_bus_index)
@onready var curent_sfx_DB = AudioServer.get_bus_volume_db(sfx_bus_index)
@onready var curent_explosions_DB = AudioServer.get_bus_volume_db(explosions_bus_index)

var lowest_db : float = -80
var fade_speed : float = 10

const NIGHT_TIME_WIND_WHISTLING = preload("uid://bwn5r0eekogkq")
const OUT_OF_BREATH_HEAVY_MALE = preload("uid://cfpfpg1s06gni")
const TINNITUS = preload("uid://cwtpeduhorxbe")
const HEARTBEAT_SOUND = preload("uid://cwoy0cxj3jivn")


const TURN_BACK_0 = preload("uid://igunpplmegpw")
const TURN_BACK_1 = preload("uid://ge6f6n5hwvp4")
const TURN_BACK_2 = preload("uid://ctvlohju74u1p")
const TURN_BACK_3 = preload("uid://b37k6evqr1ehi")

var voice_lines_return_to_trenches : Array = [TURN_BACK_0, TURN_BACK_1, TURN_BACK_2, TURN_BACK_3]

var make_quiet : bool = false
var return_sound : bool = false

func _process(delta: float) -> void:
	if make_quiet:
		if curent_BG_DB >= lowest_db:
			curent_BG_DB -= fade_speed * delta
			AudioServer.set_bus_volume_db(bg_sound_bus_index, curent_BG_DB)
		if curent_explosions_DB >= lowest_db:
			curent_explosions_DB -= fade_speed * delta
			AudioServer.set_bus_volume_db(explosions_bus_index, curent_explosions_DB)
		
		if curent_BG_DB <= lowest_db  and curent_explosions_DB <= lowest_db:
			make_quiet = false
	
	if return_sound:
		if curent_BG_DB <= highest_BG_DB:
			curent_BG_DB += fade_speed * delta
			AudioServer.set_bus_volume_db(bg_sound_bus_index, curent_BG_DB)
		if curent_explosions_DB <= highest_explosions_DB:
			curent_explosions_DB += fade_speed * delta
			AudioServer.set_bus_volume_db(explosions_bus_index, curent_explosions_DB)
		
		
		if curent_BG_DB >= highest_BG_DB and curent_explosions_DB >= highest_explosions_DB:
			return_sound = false

func play_BG() -> void:
	bg_sound.stream = NIGHT_TIME_WIND_WHISTLING
	
	bg_sound.play()

func complete_silence() -> void:
	var bus_id = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_id, -80)

func undo_complete_silence() -> void:
	var bus_id = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_id, 0)

func play_return_to_trenches() -> void:
	var random_line_id = randi_range(0, voice_lines_return_to_trenches.size() - 1)
	var voice_line : AudioStream = voice_lines_return_to_trenches[random_line_id]
	
	va.stream = voice_line
	va.play()

func play_breathing() -> void:
	breathing.stream = OUT_OF_BREATH_HEAVY_MALE
	breathing.play()

func play_beep() -> void:
	sfx.stream = TINNITUS
	
	var my_random_number = randf_range(0, 1)
	if my_random_number <= 0.5:
		sfx.play()

func play_heartbeat() -> void:
	sfx.stream = HEARTBEAT_SOUND
	
	sfx.play()

func _on_breathing_finished() -> void:
	if GameManager.player.started_panic_attack == true:
		play_breathing()
