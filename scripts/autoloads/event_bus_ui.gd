extends Node

signal pause()
signal resume()

signal deck_ui_update(available: int, total: int)
signal shopping_cart_ui_update(cart: Dictionary)
signal wishlist_ui_update(wishlist: Dictionary)

func _ready():
	pause.connect(_on_pause)
	resume.connect(_on_resume)

func _on_pause():
	get_tree().paused = true

func _on_resume():
	get_tree().paused = false
