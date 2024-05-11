class_name Deck extends Node2D

@export
var available: int = 0

@export
var total: int = 3

var cards_list: Array[Card]

func _ready():
	EventBusGame.deck_update.connect(_on_deck_update)

func _process(_delta):
	if EventBusGame.running:
		if available == 0:
			EventBusGame.deck_empty.emit()

func clear():
	cards_list = []
	available = 0
	EventBusUi.deck_counter_update.emit(available, total)

func _on_deck_update(cards: Array[Card]):
	# Update cards indexes and list
	var cards_size: int = cards.size()
	for i: int in cards_size:
		cards[i].index = i
		cards_list.append(cards[i])
	# Update counters
	available = cards_size
	EventBusUi.deck_counter_update.emit(available, total)
