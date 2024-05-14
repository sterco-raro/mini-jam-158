extends MarginContainer

@onready
var _triangle_label: Label = %TriangleLabel

@onready
var _rectangle_label: Label = %RectangleLabel

@onready
var _circle_label: Label = %CircleLabel

func _ready():
	EventBusUi.shopping_cart_ui_update.connect(_on_shopping_cart_ui_update)

func _on_shopping_cart_ui_update(shopping_cart: Dictionary):
	_triangle_label.text 	= "%d" % shopping_cart["Triangle"]
	_rectangle_label.text 	= "%d" % shopping_cart["Rectangle"]
	_circle_label.text 		= "%d" % shopping_cart["Circle"]
