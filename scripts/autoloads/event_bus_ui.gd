extends Node

# Game state
signal pause()
signal resume()

# Deck UI
signal deck_counter_update(available: int, total: int)

func _ready():
	pause.connect(_on_pause)
	resume.connect(_on_resume)

func _on_pause():
	get_tree().paused = true

func _on_resume():
	get_tree().paused = false
