class_name PlayerSound
extends Node

@onready var bg_sound: AudioStreamPlayer3D = $"../pauseble/BGSound"
@onready var sfx: AudioStreamPlayer3D = $"../pauseble/SFX"
@onready var breathing: AudioStreamPlayer3D = $"../pauseble/Breathing"
@onready var va: AudioStreamPlayer3D = $"../pauseble/VA"

@onready var BG_DB : float = bg_sound.volume_db
@onready var sfx_DB : float = sfx.volume_db

const NIGHT_TIME_WIND_WHISTLING = preload("uid://bwn5r0eekogkq")
const OUT_OF_BREATH_HEAVY_MALE = preload("uid://cfpfpg1s06gni")
const TINNITUS = preload("uid://cwtpeduhorxbe")

const TURN_BACK_0 = preload("uid://igunpplmegpw")
const TURN_BACK_1 = preload("uid://ge6f6n5hwvp4")
const TURN_BACK_2 = preload("uid://ctvlohju74u1p")
const TURN_BACK_3 = preload("uid://b37k6evqr1ehi")

var voice_lines_return_to_trenches : Array = [TURN_BACK_0, TURN_BACK_1, TURN_BACK_2, TURN_BACK_3]

var sound_tween : Tween 



func play_BG() -> void:
	bg_sound.stream = NIGHT_TIME_WIND_WHISTLING
	
	bg_sound.play()


func play_return_to_trenches() -> void:
	var random_line_id = randi_range(0, voice_lines_return_to_trenches.size() - 1)
	var voice_line : AudioStream = voice_lines_return_to_trenches[random_line_id]
	
	va.stream = voice_line
	va.play()

func make_quiet() -> void:
	var lowest_db = -160
	var sound_duration = 1
	
	sound_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	sound_tween.tween_property(bg_sound, "volume_db", lowest_db, sound_duration)
	sound_tween.tween_property(sfx, "volume_db", lowest_db, sound_duration)

func return_sound() -> void:
	var sound_duration = 1
	
	var sound_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	sound_tween.tween_property(bg_sound, "volume_db", BG_DB, sound_duration)
	sound_tween.tween_property(sfx, "volume_db", sfx_DB, sound_duration)

func play_breathing() -> void:
	breathing.stream = OUT_OF_BREATH_HEAVY_MALE
	breathing.play()

func play_beep() -> void:
	sfx.stream = TINNITUS
	
	var my_random_number = randf_range(0, 1)
	
	if my_random_number <= 0.5:
		sfx.play()
		var lowest_db = -80
		var sound_duration = 1
		
		var sound_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		sound_tween.tween_property(sfx, "volume_db", lowest_db, sound_duration)
