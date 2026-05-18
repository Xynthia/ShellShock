class_name DogtagManager
extends Node

var dogtags_in_world : int = 5
var dogtags_picked_up : int = 0

var checking_dogtags_currently : bool = false
enum arm_positions {DOWN, UP}
var current_arm_position : arm_positions = arm_positions.DOWN

@onready var xyn_arm_l_2: Node3D = $"../pauseble/ArmAndDogtags/Xyn_ArmL2"
@onready var dog_tag: Node3D = $"../pauseble/ArmAndDogtags/Xyn_ArmL2/DogTag"
@onready var dog_tag_2: Node3D = $"../pauseble/ArmAndDogtags/Xyn_ArmL2/DogTag2"
@onready var dog_tag_3: Node3D = $"../pauseble/ArmAndDogtags/Xyn_ArmL2/DogTag3"
@onready var dog_tag_4: Node3D = $"../pauseble/ArmAndDogtags/Xyn_ArmL2/DogTag4"
@onready var dog_tag_5: Node3D = $"../pauseble/ArmAndDogtags/Xyn_ArmL2/DogTag5"


@onready var animation_player: AnimationPlayer = $"../pauseble/ArmAndDogtags/AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.dogtag_manager = self
	xyn_arm_l_2.visible = false
	show_amount_dogtags_found()
	arm_down()

func checking_dogtags() -> void:
	if checking_dogtags_currently && current_arm_position == arm_positions.UP:
		await arm_down()
		show_amount_dogtags_found()
		arm_up()
		checking_dogtags_currently = false
	else:
		checking_dogtags_currently = true
		show_amount_dogtags_found()
		if GameManager.player.camera_pivot.current_look_pos != GameManager.player.camera_pivot.look_position.UP:
			GameManager.player.camera_pivot.move_to(GameManager.player.camera_pivot.look_position.UP)
		arm_up()

func stop_checking_dogtags() -> void:
	arm_down()

func show_amount_dogtags_found() -> void:
	match dogtags_picked_up:
		0:
			dog_tag.visible = false
			dog_tag_2.visible = false
			dog_tag_3.visible = false
			dog_tag_4.visible = false
			dog_tag_5.visible = false
		1:
			dog_tag.visible = true
			dog_tag_2.visible = false
			dog_tag_3.visible = false
			dog_tag_4.visible = false
			dog_tag_5.visible = false
		2:
			dog_tag.visible = true
			dog_tag_2.visible = true
			dog_tag_3.visible = false
			dog_tag_4.visible = false
			dog_tag_5.visible = false
		3:
			dog_tag.visible = true
			dog_tag_2.visible = true
			dog_tag_3.visible = true
			dog_tag_4.visible = false
			dog_tag_5.visible = false
		4:
			dog_tag.visible = true
			dog_tag_2.visible = true
			dog_tag_3.visible = true
			dog_tag_4.visible = true
			dog_tag_5.visible = false
		5:
			dog_tag.visible = true
			dog_tag_2.visible = true
			dog_tag_3.visible = true
			dog_tag_4.visible = true
			dog_tag_5.visible = true

func arm_up() -> void:
	current_arm_position = arm_positions.UP
	animation_player.play("arm_up")

func arm_down() -> bool:
	current_arm_position = arm_positions.DOWN
	animation_player.play("arm_down")
	await animation_player.animation_finished
	return true
