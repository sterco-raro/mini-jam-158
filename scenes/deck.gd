class_name Deck
extends Node

# TODO set, get item

const max_cards: int = Constants.DECK_MAX_CARDS

var available_cards: int = 0

var cards: Dictionary = {
	Constants.CARDS.ALPHA: 		0,
	Constants.CARDS.BETA:  		0,
	Constants.CARDS.GAMMA: 		0,
	Constants.CARDS.DELTA: 		0,
	Constants.CARDS.EPSILON: 	0,
}


func is_empty() -> bool:
	for key in cards:
		if cards[key] > 0:
			return false
	return true


func clear():
	for key in cards:
		cards[key] = 0
	available_cards = 0
	EventBusUi.deck_ui_update.emit(available_cards, max_cards)


func update(new_cards: Array[Card]):
	clear()
	for card: Card in new_cards:
		cards[card.type] += 1
	available_cards = new_cards.size()
	EventBusUi.deck_ui_update.emit(available_cards, max_cards)
