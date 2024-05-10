extends Node

signal change_scene(instance: Node)
# Draft phase
signal new_game()
# Game phase
signal start_game()
# Battle phase
signal start_battle()
# Back to Game phase
signal end_battle()
# Show results
signal end_game()

func _ready():
	pass
