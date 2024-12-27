extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HighScore/HighScoreStr.text = format_score(Globals.high_score)
	$CurrScore/CurrScoreStr.text = format_score(Globals.current_score)
	update_info(Globals.current_score)

func format_score(score: int) -> String:
	if score > 9999:
		score = 9999
	var padded = "0000" + str(score)
	return padded.substr(padded.length() - 4, 4)
	
func update_info(score: int) -> void:
	if score > 50:
		$InfoStr.text = "Вот это класс! Лови промокод ЛУЧШИЙМАРИО на скидку 700 рублей! Примени его, когда будешь покупать билет на Заячий стон!";
		return
	if score > 30:
		$InfoStr.text = "Молодец! Твой приз - промокод на 500 рублей ПРЫГУН3000. Примени его, когда будешь покупать билет на Заячий стон!";
		return
	$InfoStr.text = "Ну, дела. Не расстраивай Виталика, сыграй ещё раз!"

func _on_web_btn_pressed() -> void:
	OS.shell_open("https://www.zayachiyston.ru/?utm_source=offline&utm_medium=game&utm_campaign=banner")

func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
