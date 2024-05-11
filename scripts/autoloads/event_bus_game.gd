extends Node

signal scene_change(instance: Node)

# Draft phase
signal game_new()
# Market phase
signal game_start()
# Results screen
signal game_end()

# From market to battle phase
signal battle_start()
# From battle back to market phase
signal battle_end()

signal card_select(index: int)
signal draft_card_select(idx: int, selected: bool)

signal deck_empty()
signal deck_update(available: int, total: int)

var running: bool = false

func _ready():
	game_start.connect(_on_game_start)
	game_end.connect(_on_game_end)

func _on_game_start():
	running = true

func _on_game_end():
	running = false
