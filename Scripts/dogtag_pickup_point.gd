class_name DogtagPickupPoint
extends Node3D

@onready var sm_helmet_british_01: Node3D = $SM_HelmetBritish01
@onready var walking_point: VisibleOnScreenNotifier3D = $WalkingPoint

var looking_at : bool = false
var picked_up_dogtag : bool = false

func picked_up() -> void:
	picked_up_dogtag = true
	sm_helmet_british_01.visible = false
	GameManager.player.dogtags.dogtags_picked_up += 1
	GameManager.player.dogtags.dogtags_in_world -= 1

func _on_walking_point_screen_entered() -> void:
	looking_at = true

func _on_walking_point_screen_exited() -> void:
	looking_at = false
