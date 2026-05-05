class_name PlayerAnimations
extends Node

@onready var animation_player: AnimationPlayer = $"../pauseble/eyelids/AnimationPlayer"

var closed_eyes_done : bool = false
var amount_blink : int

func blink():
	animation_player.play("blink")

func close_eyes() -> void:
	animation_player.play("close_eyes")

func closed_eyes() -> void:
	animation_player.play("closed_eyes")
	closed_eyes_done = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "blink" && GameManager.player.started_ending || anim_name == "blink" && GameManager.player.started_panic_attack:
		blink()
		amount_blink += 1
		if amount_blink >= 3:
			close_eyes()
	if anim_name == "close_eyes":
		closed_eyes()
		
