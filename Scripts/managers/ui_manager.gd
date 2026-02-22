class_name UIManager
extends Node3D

@onready var main_menu_ui: VBoxContainer = $CanvasLayer/Panel/MarginContainer/MainMenuUI
@onready var settings_ui: VBoxContainer = $CanvasLayer/Panel/MarginContainer/SettingsUI
@onready var pause_menu_ui: VBoxContainer = $CanvasLayer/Panel/MarginContainer/PauseMenuUI
@onready var disclaimer_ui: VBoxContainer = $CanvasLayer/Panel/MarginContainer/DisclaimerUI

@onready var panel: Panel = $CanvasLayer/Panel

@onready var tutorial_label: RichTextLabel = $CanvasLayer/RichTextLabel

func _ready() -> void:
	proceed_disclaimer()

func proceed_disclaimer() -> void:
	get_tree().create_timer(25).timeout.connect(make_main_menu_visible)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && disclaimer_ui.visible:
		make_main_menu_visible()

func make_main_menu_visible() -> void:
	disclaimer_ui.visible = false
	main_menu_ui.visible = true

func start_game() -> void:
	GameManager.start_game()

func open_settings() -> void:
	main_menu_ui.visible = false
	settings_ui.visible = true
	pause_menu_ui.visible = false


func back() -> void:
	if get_tree().paused == true:
		panel.visible = true
		pause_menu_ui.visible = true
	else:
		panel.visible = true
		main_menu_ui.visible = true
	
	settings_ui.visible = false
	

func pause_menu() -> void:
	if panel.visible && pause_menu_ui.visible:
		main_menu_ui.visible = true
		pause_menu_ui.visible = false
		panel.visible = false
		get_tree().paused = false
	else:
		main_menu_ui.visible = false
		pause_menu_ui.visible = true
		panel.visible = true
		get_tree().paused = true
	

func _on_back_to_game_button_pressed() -> void:
	pause_menu()

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

func _on_mouse_sensitivity_value_changed(value: float) -> void:
	if GameManager.started_game:
		GameManager.player.mouse_sensitivity = value
	else: 
		GameManager.mouse_sensitivity = value
