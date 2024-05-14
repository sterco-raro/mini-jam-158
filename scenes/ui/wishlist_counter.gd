extends MarginContainer

@onready
var _triangle_label: Label = %TriangleLabel

@onready
var _rectangle_label: Label = %RectangleLabel

@onready
var _circle_label: Label = %CircleLabel

func _ready():
	EventBusUi.wishlist_ui_update.connect(_on_wishlist_ui_update)

func _on_wishlist_ui_update(wishlist: Dictionary):
	_triangle_label.text 	= "%d" % wishlist["Triangle"]
	_rectangle_label.text 	= "%d" % wishlist["Rectangle"]
	_circle_label.text 		= "%d" % wishlist["Circle"]
