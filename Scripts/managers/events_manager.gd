class_name EventsManager
extends Node3D

@onready var va: AudioStreamPlayer3D = $VA

const LOS_0 = preload("uid://dhrifmuxk0y76")
const LOS_1 = preload("uid://ck2cpk7mwt7n1")
const LOS_2 = preload("uid://dkd3caonjnpvd")
const LOS_3 = preload("uid://dphjrxha6vxej")
const LOS_4 = preload("uid://dyp6fipk2r1wr")
const TAKE_THE_TRENCH_0 = preload("uid://bho6d82n8m677")
const TAKE_THE_TRENCH_1 = preload("uid://dgnuoy5pp0f04")
const TAKE_THE_TRENCH_2 = preload("uid://bkvk35a1x1h27")
const TAKE_THE_TRENCH_3 = preload("uid://csm0c3rlwq0wp")
const THEYRE_HERE_0 = preload("uid://djgb2we6g222n")
const THEYRE_HERE_1 = preload("uid://drrng8g7dyspw")
const THEYRE_HERE_2 = preload("uid://dhu6462c46anp")
const THEYRE_HERE_3 = preload("uid://7w77luxmtqug")

var va_los : Array = [LOS_0, LOS_1, LOS_2, LOS_3, LOS_4]
var va_take_the_trenches : Array = [TAKE_THE_TRENCH_0, TAKE_THE_TRENCH_1, TAKE_THE_TRENCH_2, TAKE_THE_TRENCH_3]
var va_theyre_here : Array = [THEYRE_HERE_0, THEYRE_HERE_1, THEYRE_HERE_3]

var va_sentences : Array = [va_los, va_take_the_trenches, va_theyre_here]

var last_event_timer : float = 0
var last_event_time : float = 3 * 60
@export var play_this_once : bool = true
var do_this_once_2 : bool = true

var player_va_sounds : bool = false
var player_in_front_line : bool = false

var started_tutorial : bool = false
var controls_a_d : bool = false
var controls_w : bool = false
var controls_mouse : bool = false
var controls_escape : bool = false

var start_color: Color =  Color(1, 1, 1, 0)
var mid_color: Color =  Color(1, 1, 1, 1)
var end_color: Color =  Color(1, 1, 1, 0)
var transition : float = 0.3
var finished_fade_in : bool = false
var finished_fade_out: bool = false

var tutorial_sentances : Array[String] = [
	"You can turn left (A) and right (D)",
	"You can move foward (W)",
	"You can look around (MOUSE UP, DOWN, LEFT & RIGHT)",
	"You can also pause the game (ESC)"
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.events_manager = self
	started_tutorial = true
	GameManager.ui.tutorial_label.modulate = start_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameManager.finished_tutrial:
		if !GameManager.player.movement.turned_left && !GameManager.player.movement.turned_right && started_tutorial && !controls_a_d:
			GameManager.ui.tutorial_label.text = tutorial_sentances[0]
			fade_in()
		
		if finished_fade_in && GameManager.player.movement.turned_left && GameManager.player.movement.turned_right && started_tutorial && !controls_a_d:
			controls_a_d = true
			fade_out()
		
		if !GameManager.player.movement.moved_foward && controls_a_d && finished_fade_out && !controls_w:
			GameManager.ui.tutorial_label.text = tutorial_sentances[1]
			fade_in()
			
		if GameManager.player.movement.moved_foward && controls_a_d && finished_fade_in && !controls_w:
			controls_w = true
			fade_out()
		
		if !GameManager.player.camera_pivot.moved_down && !GameManager.player.camera_pivot.moved_up && controls_w && !GameManager.player.camera_pivot.moved_left && !GameManager.player.camera_pivot.moved_right && !controls_mouse && finished_fade_out:
			GameManager.ui.tutorial_label.text = tutorial_sentances[2]
			fade_in()
		
		if GameManager.player.camera_pivot.moved_down && GameManager.player.camera_pivot.moved_up && controls_w  && GameManager.player.camera_pivot.moved_left && GameManager.player.camera_pivot.moved_right && !controls_mouse && finished_fade_in:
			controls_mouse = true
			fade_out()
		
		if !GameManager.player.pressed_escape && controls_mouse && finished_fade_out && !controls_escape:
			GameManager.ui.tutorial_label.text = tutorial_sentances[3]
			fade_in()
		
		if GameManager.player.pressed_escape && controls_mouse && finished_fade_in && !controls_escape:
			controls_escape = true
			GameManager.finished_tutrial = true
			fade_out()
		
	#if GameManager.finished_tutrial:
		#last_event_timer += delta
	
	if last_event_timer >= last_event_time && !player_va_sounds && do_this_once_2:
		play_VA_sounds()
		do_this_once_2 = false
	
	if last_event_timer >= last_event_time && player_in_front_line && player_va_sounds && play_this_once:
		play_VA_sounds()
		GameManager.player.can_be_hit_for_end_scene = true
		play_this_once = false
	
	
	if GameManager.player && GameManager.player.animations.closed_eyes_done && GameManager.player.started_ending:
		GameManager.player.started_ending = false
		GameManager.start_credits()
	
	if GameManager.player && GameManager.player.animations.closed_eyes_done && GameManager.player.started_panic_attack:
		GameManager.player.fase_four_panic_attack()

func fade_in() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(GameManager.ui.tutorial_label, "modulate", mid_color, transition)
	
	tween.finished.connect(fade_in_finished)

func fade_out() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(GameManager.ui.tutorial_label, "modulate", end_color, transition)
	
	tween.finished.connect(fade_out_finished)

func fade_in_finished() -> void:
	finished_fade_in = true
	finished_fade_out = false

func fade_out_finished() -> void:
	finished_fade_out = true
	finished_fade_in = false


func play_VA_sounds() -> void:
	var random_id_sentences = randf_range(0, va_sentences.size() - 1)
	var random_voice_line_array : Array = va_sentences[random_id_sentences]
	var random_id_random_voice_lines = randf_range(0, random_voice_line_array.size() - 1)
	var voiceline : AudioStream = random_voice_line_array[random_id_random_voice_lines]
	
	va.stream = voiceline
	va.play()
	va.finished.connect(finished_va)

func finished_va() -> void:
	player_va_sounds = true

func _on_shot_manager_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_front_line = true


func _on_frontline_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_front_line = false
