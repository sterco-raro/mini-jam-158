class_name Item extends Node2D

@export
var price: int = 0

func _ready():
	assert(price > 0, "Price is zero")
