class_name Item extends Node2D

@export
var type: String = ""

func _ready():
	assert(type != "", "Item type is null")
