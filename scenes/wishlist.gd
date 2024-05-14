class_name Wishlist
extends Node2D

var wishlist: Dictionary = {
	"Circle": 0,
	"Rectangle": 0,
	"Triangle": 0,
}


func _ready() -> void:
	EventBusGame.wishlist_clear.connect(_on_wishlist_clear)
	EventBusGame.wishlist_update.connect(_on_wishlist_update)


func _clear():
	for key in wishlist.keys():
		wishlist[key] = 0


func _on_wishlist_clear():
	_clear()
	EventBusUi.wishlist_ui_update.emit(wishlist)


func _on_wishlist_update(data: Dictionary):
	_clear()
	for key: String in data.keys():
		wishlist[key] = data[key]

	EventBusGame.wishlist_ui_update.emit(wishlist)
