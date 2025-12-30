class_name Shot
extends Node3D

@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D

@onready var bullet_body: Area3D = $"Path3D/PathFollow3D/bullet Body"

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"Path3D/PathFollow3D/bullet Body/AudioStreamPlayer3D"

@onready var trauma_causer: Area3D = $"Path3D/PathFollow3D/bullet Body/TraumaCauser"
@onready var collision_shape_3d: CollisionShape3D = $"Path3D/PathFollow3D/bullet Body/TraumaCauser/CollisionShape3D"

@onready var muzzleflash: Node3D = $muzzleflash


const MIXED_LONG_DISTANCE_SHOT = preload("uid://q5pbmggc6vqa")
const RICOCHET_METALLIC_HIT = preload("uid://drnh5olui67mw")

const FAST_PROJECTILE_FLY_BY_WHOOSH = preload("uid://bcqrmbwld4en5")


var hit_timer : float = 1
var hit_time : float = 3

var move_speed = 50

var do_this_once = true
var didnt_hit_player = true

func _ready() -> void:
	play_shooting_object()
	muzzleflash.particle_start()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		play_shot_past_player()
		didnt_hit_player = false
		trauma_causer.cause_trauma()

func _physics_process(delta: float) -> void:
	path_follow_3d.progress += move_speed * get_process_delta_time()
	if path_follow_3d.progress_ratio == 1 && do_this_once:
		hit()
		do_this_once = false
	elif path_follow_3d.progress_ratio == 1:
		hit_timer += delta
		
		if hit_timer >= hit_time:
			GameManager.shot_manager.shots.erase(self)
			queue_free()

func hit() -> void:
	if didnt_hit_player:
		play_shot_on_ground()
	
	bullet_body.visible = false

func play_shot_on_ground() -> void:
	audio_stream_player_3d.stream = RICOCHET_METALLIC_HIT
	audio_stream_player_3d.play()

func play_shot_past_player() -> void:
	audio_stream_player_3d.stream = FAST_PROJECTILE_FLY_BY_WHOOSH
	audio_stream_player_3d.play()

func play_shooting_object() -> void:
	audio_stream_player_3d.stream = MIXED_LONG_DISTANCE_SHOT
	audio_stream_player_3d.play()
