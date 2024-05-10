extends CenterContainer

func _on_button_1_pressed():
	EventBusGame.new_game.emit()

func _on_button_2_pressed():
	get_tree().quit(0)
