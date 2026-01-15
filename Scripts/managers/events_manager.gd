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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.events_manager = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	last_event_timer += delta
	
	if last_event_timer >= last_event_time && play_this_once:
		play_VA_sounds()
		GameManager.player.can_be_hit_for_end_scene = true
		play_this_once = false
	

func play_VA_sounds() -> void:
	var random_id_sentences = randf_range(0, va_sentences.size() - 1)
	var random_voice_line_array : Array = va_sentences[random_id_sentences]
	var random_id_random_voice_lines = randf_range(0, random_voice_line_array.size() - 1)
	var voiceline : AudioStream = random_voice_line_array[random_id_random_voice_lines]
	
	va.stream = voiceline
	va.play()
