extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$bg/FarCityParallax.hide()
	$bg/CloseCityParallax.hide()
	$HighScore/HighScoreStr.text = format_score(Globals.high_score)
	$CurrScore/CurrScoreStr.text = format_score(Globals.current_score)
	update_info(Globals.current_score)

func format_score(score: int) -> String:
	if score > 9999:
		score = 9999
	var padded = "0000" + str(score)
	return padded.substr(padded.length() - 4, 4)
	
func update_info(score: int) -> void:
	if score > 60:
		$Good.show()
		$Bad.hide()
		$Good/win500.hide()
		$Good/win700.show()
		return
	if score > 30:
		$Good.show()
		$Bad.hide()
		$Good/win500.show()
		$Good/win700.hide()
		return
	$Good.hide()
	$Bad.show()

func _process(delta: float) -> void:
	$bg/RoadParallax.motion_offset.x += (-10 * delta)
	$bg/CloudsParallax.motion_offset.x += (20 * delta)

func _on_web_btn_pressed() -> void:
	OS.shell_open("https://www.zayachiyston.ru/?utm_source=offline&utm_medium=game&utm_campaign=banner")

func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_win_500_pressed() -> void:
	DisplayServer.clipboard_set("ПРЫГУН3000")


func _on_win_700_pressed() -> void:
	DisplayServer.clipboard_set("ЛУЧШИЙМАРИО")


func _on_mariam_pressed() -> void:
	OS.shell_open("https://www.artstation.com/sourwaters")


func _on_daulet_pressed() -> void:
	OS.shell_open("https://www.linkedin.com/in/daulet-t")
