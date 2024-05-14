extends Control


func _on_button_1_pressed():
	EventBusGame.game_new.emit()
