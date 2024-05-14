class_name Deck
extends Node

# TODO set, get item

var available: int = 0
var max_cards: int = Constants.DECK_MAX_CARDS

var cards: Dictionary = {
	"Alpha": 	{ "value": 1,  "quantity": 0 },
	"Beta":  	{ "value": 5,  "quantity": 0 },
	"Gamma": 	{ "value": 10, "quantity": 0 },
	"Delta": 	{ "value": 20, "quantity": 0 },
	"Epsilon": 	{ "value": 50, "quantity": 0 }
}


func is_empty() -> bool:
	for key: String in cards:
		if cards[key]["quantity"] > 0:
			return false
	return true


func clear():
	for key: String in cards:
		cards[key]["quantity"] = 0
	available = 0
	EventBusUi.deck_ui_update.emit(available, max_cards)


func update(new_cards: Array[Card]):
	clear()
	for card: Card in new_cards:
		cards[card.type]["quantity"] += 1
	available = new_cards.size()
	EventBusUi.deck_ui_update.emit(available, max_cards)
