class_name ShoppingCart
extends Node2D

var cart: Dictionary = {
	"Circle": 0,
	"Rectangle": 0,
	"Triangle": 0,
}


func _ready() -> void:
	EventBusGame.shopping_cart_clear.connect(_on_shopping_cart_clear)
	EventBusGame.shopping_cart_update.connect(_on_shopping_cart_update)


func _clear():
	for key in cart.keys():
		cart[key] = 0


func _on_shopping_cart_clear():
	_clear()
	EventBusUi.shopping_cart_ui_update.emit(cart)


func _on_shopping_cart_update(data: Dictionary):
	_clear()
	for key: String in data.keys():
		cart[key] = data[key]

	EventBusGame.shopping_cart_ui_update.emit(cart)
