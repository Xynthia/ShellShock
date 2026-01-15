extends Node3D

@onready var panel: Panel = $CanvasLayer/Panel
@onready var margin_container: MarginContainer = $CanvasLayer/Panel/MarginContainer

var beginning_color : Color = Color(1, 1, 1, 0)
var mid_color : Color = Color(1.0, 1.0, 1.0, 1.0)
var ending_color : Color = Color(0, 0, 0, 1)

var transision : float = 5

var credits_time : float = 20
var credits_timer : float

var started_timer : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.modulate = beginning_color
	get_tree().create_timer(5).timeout
	fade_in()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started_timer:
		credits_timer += delta
		if credits_timer >= credits_time:
			fade_out()

func fade_in() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(panel, "modulate", mid_color, transision)
	
	tween.finished.connect(start_timer)

func fade_out() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(panel, "modulate", ending_color, transision)
	
	tween.finished.connect(finished_fade)

func start_timer() -> void:
	started_timer = true
	var end_pos_y : float = -920.0
	var end_pos : Vector2 = Vector2(position.x , end_pos_y)
	
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(margin_container, "position", end_pos, credits_time)
	


func finished_fade() -> void:
	GameManager.start_main_menu()
