class_name Item extends Node2D

@export
var type: String = ""

@export
var price: int = 0

func _ready():
	assert(type != "", "Item type is null")
	assert(price > 0, "Item price is zero")
