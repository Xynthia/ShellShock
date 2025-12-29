class_name Grenade
extends Node3D

@onready var grenade_body: Area3D = $"Path3D/PathFollow3D/Grenade Body"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"Path3D/PathFollow3D/Grenade Body/AudioStreamPlayer3D"


@onready var trauma_causer: Area3D = $TraumaCauser
@onready var collision_shape_3d: CollisionShape3D = $TraumaCauser/CollisionShape3D


@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D

@onready var explosion_particles: Node3D = $Explosion


const WHOOSH_THROWING_AN_OBJECT = preload("uid://cawikrapdwpto")
const SMALL_GRENADE_EXPLOSION = preload("uid://bnv38w7p2jqab")


var move_speed = 150

var do_this_once = true
var time_to_scale = 0.8
var new_scale : Vector3 = Vector3(10, 10, 10)

func _ready() -> void:
	play_trowing_object()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		trauma_causer.cause_trauma()

func _physics_process(delta: float) -> void:
	path_follow_3d.progress += move_speed * get_process_delta_time()
	if path_follow_3d.progress_ratio == 1 && do_this_once:
		explosion()
		

func explosion() -> void:
	explosion_particles.particle_start()
	play_explosion()
	trauma_causer_up_scale()

func trauma_causer_up_scale() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(collision_shape_3d, "scale", new_scale, time_to_scale)
	
	do_this_once = false

func play_explosion() -> void:
	audio_stream_player_3d.stream = SMALL_GRENADE_EXPLOSION
	audio_stream_player_3d.play()

func play_trowing_object() -> void:
	audio_stream_player_3d.stream = WHOOSH_THROWING_AN_OBJECT
	audio_stream_player_3d.play()
