class_name PlayerAnimations
extends Node

@onready var animation_player: AnimationPlayer = $"../pauseble/eyelids/AnimationPlayer"
@onready var vignette: ColorRect = $"../pauseble/eyelids/vignette"

var closed_eyes_done : bool = false
var amount_blink : int
var panic_attack_playing : bool = false

func _ready() -> void:
	vignette.visible = false

func _process(delta: float) -> void:
	if GameManager.player.amount_interaction_panic_atttack < 0 && !GameManager.started_death:
		vignette.visible = true
		if !panic_attack_playing:
			panic_attack()
	else:
		vignette.visible = false

func panic_attack() -> void:
	panic_attack_playing = true
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
