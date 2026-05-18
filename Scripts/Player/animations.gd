class_name PlayerAnimations
extends Node

@onready var animation_player: AnimationPlayer = $"../pauseble/eyelids/AnimationPlayer"
@onready var vignette: ColorRect = $"../pauseble/eyelids/vignette"
@onready var blur: ColorRect = $"../pauseble/eyelids/blur"

var closed_eyes_done : bool = false
var amount_blink : int
var panic_attack_playing : bool = false

var started_rapid_blur : bool = false
var rapid_blur_timer : float = 0
var rapid_blur_time : float = 0.2
var max_amount_rapid_blur : int = 10
var amount_rapid_blur : int = 0

func _ready() -> void:
	vignette.visible = false
	blur.visible = false

func _process(delta: float) -> void:
	if started_rapid_blur:
		rapid_blur_timer += delta
		if rapid_blur_timer >= rapid_blur_time:
			amount_rapid_blur += 1
			rapid_blur()
		if amount_rapid_blur >= max_amount_rapid_blur:
			GameManager.player.fase_two_panic_attack()
	
	if GameManager.player.started_panic_attack && !GameManager.started_death && GameManager.player.amount_interaction_panic_atttack < GameManager.player.starting_amount_interaction_panic_atttack:
		vignette.material.set_shader_parameter("radius", GameManager.player.amount_interaction_panic_atttack)


func rapid_blur() -> void:
	blur.visible = true
	panic_attack()
	rapid_blur_timer = 0.0
	started_rapid_blur = true

func stop_blur() -> void:
	blur.visible = false
	started_rapid_blur = false

func long_blur() -> void:
	amount_rapid_blur = 0
	blur.visible = true

func play_vignette() -> void:
	vignette.visible = true

func stop_vignette() -> void:
	vignette.visible = false

func panic_attack() -> void:
	animation_player.play("panic attack")

func blink():
	animation_player.play("blink")

func close_eyes() -> void:
	animation_player.play("close_eyes")

func closed_eyes() -> void:
	animation_player.play("closed_eyes")
	closed_eyes_done = true

func open_eyes() -> void:
	animation_player.play("RESET")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "blink" && GameManager.player.started_ending || anim_name == "blink" && GameManager.player.started_panic_attack:
		blink()
		amount_blink += 1
		if amount_blink >= 3:
			close_eyes()
	if anim_name == "close_eyes":
		closed_eyes()
	if anim_name == "panic attack":
		panic_attack_playing = false
