class_name Artillery
extends Node3D

@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D

@onready var trauma_causer: Area3D = $TraumaCauser
@onready var collision_shape_3d: CollisionShape3D = $TraumaCauser/CollisionShape3D

@onready var arty_body: Area3D = $"Path3D/PathFollow3D/Arty Body"


@onready var explosion_particles: Node3D = $Explosion

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"Path3D/PathFollow3D/Arty Body/AudioStreamPlayer3D"
@onready var audio_stream_player_3d_2: AudioStreamPlayer3D = $AudioStreamPlayer3D2


const MI_155_MM_HOWITZER = preload("uid://2sawfamd5x5t")
const BOMB_DROP_WHISTLING = preload("uid://dfis7h2tv5ljm")
const BIG_EXPLOSION_CLOSE = preload("uid://b3arg48k1dqkr")

var explosion_timer : float = 1
var explosion_time : float = 5

var move_speed = 150

var do_this_once = true
var time_to_scale = 0.8
var new_scale : Vector3 = Vector3(100, 100, 100)

func _ready() -> void:
	play_trowing_object()
	play_whistle()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		trauma_causer.cause_trauma()

func _physics_process(delta: float) -> void:
	path_follow_3d.progress += move_speed * get_process_delta_time()
	if path_follow_3d.progress_ratio == 1 && do_this_once:
		explosion()
	elif path_follow_3d.progress_ratio == 1:
		explosion_timer += delta
		
		if explosion_timer >= explosion_time:
			queue_free()

func explosion() -> void:
	explosion_particles.particle_start()
	play_explosion()
	trauma_causer_up_scale()
	arty_body.visible = false

func trauma_causer_up_scale() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(collision_shape_3d, "scale", new_scale, time_to_scale)
	
	do_this_once = false

func play_explosion() -> void:
	audio_stream_player_3d.stream = BIG_EXPLOSION_CLOSE
	audio_stream_player_3d.play()

func play_trowing_object() -> void:
	audio_stream_player_3d_2.stream = MI_155_MM_HOWITZER
	audio_stream_player_3d_2.play()

func play_whistle() -> void:
	audio_stream_player_3d.stream = BOMB_DROP_WHISTLING
	audio_stream_player_3d.play()
