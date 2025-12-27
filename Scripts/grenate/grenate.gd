class_name Grenade
extends Node3D

@onready var grenade_body: Area3D = $"Path3D/PathFollow3D/Grenade Body"

@onready var trauma_causer: Area3D = $TraumaCauser

@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D

var move_speed = 150


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") && path_follow_3d.progress_ratio == 1:
		trauma_causer.cause_trauma()

func _physics_process(delta: float) -> void:
	path_follow_3d.progress += move_speed * get_process_delta_time()
	
