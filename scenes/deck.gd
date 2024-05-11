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

func _on_deck_update(cards: Array[Card]):
	# Update cards indexes and list
	var cards_size: int = cards.size()
	for i: int in cards_size:
		cards[i].index = i
		print(cards[i].type)
		cards_list.append(cards[i])
	print(cards_list)
