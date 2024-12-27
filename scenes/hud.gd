extends CanvasLayer

func set_high_score(score: int) -> void:
	$HighScore/HighScoreStr.text = format_score(score)
	
func set_score(score: int) -> void:
	$CurrScore/CurrScoreStr.text = format_score(score)

func format_score(score: int) -> String:
	if score > 9999:
		score = 9999
	var padded = "0000" + str(score)
	return padded.substr(padded.length() - 4, 4)
