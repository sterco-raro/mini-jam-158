extends MarginContainer

@onready
var _triangle_label: Label = %TriangleLabel

@onready
var _rectangle_label: Label = %RectangleLabel

@onready
var _circle_label: Label = %CircleLabel

func _ready():
	EventBusUi.shopping_cart_ui_update.connect(_on_shopping_cart_ui_update)

func _on_shopping_cart_ui_update(data: Dictionary):
	_triangle_label.text 	= "%d" % data[Constants.ITEMS.TRIANGLE]
	_rectangle_label.text 	= "%d" % data[Constants.ITEMS.RECTANGLE]
	_circle_label.text 		= "%d" % data[Constants.ITEMS.CIRCLE]
