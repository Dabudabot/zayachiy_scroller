extends Node

var CLOSE_SCALE = Vector2(2.5, 2.5)
var MED_SCALE = Vector2(2, 2)
var FAR_SCALE = Vector2(1.75, 1.75)

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_web_btn_pressed() -> void:
	OS.shell_open("https://www.zayachiyston.ru/?utm_source=offline&utm_medium=game&utm_campaign=banner")

func _process(delta: float) -> void:
	$bg/CloudsParallax.motion_offset.x += (10 * delta)

func _ready() -> void:
	Globals.force_char = true
	_on_alex_btn_pressed()

func _on_alex_btn_pressed() -> void:
	if Globals.current_char == "Alex":
		pass
	Globals.current_char = "Alex"
	$Alex.scale = CLOSE_SCALE
	$Kirill.scale = MED_SCALE
	$Max.scale = FAR_SCALE
	$Vitaliy.scale = FAR_SCALE

func _on_vitaliy_btn_pressed() -> void:
	if Globals.current_char == "Vitaliy":
		pass
	Globals.current_char = "Vitaliy"
	$Alex.scale = MED_SCALE
	$Kirill.scale = FAR_SCALE
	$Max.scale = FAR_SCALE
	$Vitaliy.scale = CLOSE_SCALE


func _on_max_btn_pressed() -> void:
	if Globals.current_char == "Max":
		pass
	Globals.current_char = "Max"
	$Alex.scale = FAR_SCALE
	$Kirill.scale = MED_SCALE
	$Max.scale = CLOSE_SCALE
	$Vitaliy.scale = FAR_SCALE


func _on_kirill_btn_pressed() -> void:
	if Globals.current_char == "Kirill":
		pass
	Globals.current_char = "Kirill"
	$Alex.scale = MED_SCALE
	$Kirill.scale = CLOSE_SCALE
	$Max.scale = FAR_SCALE
	$Vitaliy.scale = FAR_SCALE
