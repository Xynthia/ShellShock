class_name UIManager
extends Node3D

@onready var main_menu_ui: VBoxContainer = $CanvasLayer/Panel/MarginContainer/MainMenuUI
@onready var settings_ui: VBoxContainer = $CanvasLayer/Panel/MarginContainer/SettingsUI
@onready var pause_menu_ui: VBoxContainer = $CanvasLayer/Panel/MarginContainer/PauseMenuUI

@onready var panel: Panel = $CanvasLayer/Panel


func start_game() -> void:
	GameManager.start_game()

func open_settings() -> void:
	main_menu_ui.visible = false
	settings_ui.visible = true
	pause_menu_ui.visible = false


func back() -> void:
	main_menu_ui.visible = true
	settings_ui.visible = false

func pause_menu() -> void:
	if panel.visible && pause_menu_ui.visible:
		main_menu_ui.visible = true
		pause_menu_ui.visible = false
		panel.visible = false
		pause_menu_ui.z_index = 0
		get_tree().paused = false
	else:
		main_menu_ui.visible = false
		pause_menu_ui.visible = true
		panel.visible = true
		pause_menu_ui.z_index = 99
		get_tree().paused = true
	

func _on_back_to_game_button_pressed() -> void:
	pause_menu_ui.visible = false
	panel.visible = false

func quit() -> void:
	get_tree().quit()


func _on_brightness_value_changed(value: float) -> void:
	if GameManager.started_game:
		GameManager.game_environment.environment.adjustment_brightness = value
	else:
		GameManager.main_menu_environment.environment.adjustment_brightness = value

func _on_contrast_value_changed(value: float) -> void:
	if GameManager.started_game:
		GameManager.game_environment.environment.adjustment_contrast = value
	else:
		GameManager.main_menu_environment.environment.adjustment_contrast = value
