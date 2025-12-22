extends Node3D

@onready var trauma_causer: Area3D = $TraumaCauser


func _on_trauma_causer_body_entered(body: Node3D) -> void:
	trauma_causer.cause_trauma()
