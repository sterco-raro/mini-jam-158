class_name Card extends Node2D

@export
var type: String = ""

@export
var value: int = 0

@export
var index: int = 0

func _ready():
	assert(type != "", "Card type is empty")
	assert(value != 0, "Card value is zero")
