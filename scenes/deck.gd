class_name Deck extends Node2D

@export
var available: int = 0

@export
var total: int = 10

var cards: Dictionary = {
	"Alpha": 	{ "value": 1,  "quantity": 0 },
	"Beta":  	{ "value": 5,  "quantity": 0 },
	"Gamma": 	{ "value": 10, "quantity": 0 },
	"Delta": 	{ "value": 20, "quantity": 0 },
	"Epsilon": 	{ "value": 50, "quantity": 0 }
}

func _ready():
	EventBusGame.deck_update.connect(_on_deck_update)

func _process(_delta):
	if EventBusGame.running:
		if available == 0:
			EventBusGame.deck_empty.emit()

func clear():
	for key in cards.keys():
		cards[key]["quantity"] = 0
	available = 0
	EventBusUi.deck_counter_update.emit(available, total)

func _on_deck_update(new_cards: Array[Card]):
	for key in cards.keys():
		cards[key]["quantity"] = 0
	# Store new cards
	var new_cards_size: int = new_cards.size()
	for i: int in new_cards_size:
		new_cards[i].index = i
		cards[new_cards[i].type]["quantity"] += 1
	# Update counters
	available = new_cards_size
	EventBusUi.deck_counter_update.emit(available, total)
