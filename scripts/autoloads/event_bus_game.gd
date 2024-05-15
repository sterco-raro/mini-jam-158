extends Node

signal battle_card_select(card: Card)
signal battle_end(win: bool)
signal battle_request_deck()
signal battle_set_deck(cards: Array[Card])
signal battle_set_item(item: Item)
signal battle_start()

signal card_select(idx: int, selected: bool)

signal deck_add_cards(new_cards: Array[Card])
signal deck_update(new_cards: Array[Card])

signal draft_card_select(index: int)

signal game_end(win:bool)
signal game_new()
signal game_start()

signal market_item_select(index: int)

signal shopping_cart_add_item(item: Constants.ITEMS)

signal summary_update_burned_cards(cards: Array[Card])
signal summary_update_draft(cards: Array[Card])
signal summary_update_shopping_cart(cart: Dictionary)
signal summary_update_total_items_cost(total_hand_value: int)
signal summary_update_used_cards(cards: Array[Card])
signal summary_update_wishlist(list: Dictionary)

signal wishlist_randomize(items: Dictionary)

var total_items_cost: int = 0

var starting_deck: Dictionary = {
	Constants.CARDS.ALPHA: 		0,
	Constants.CARDS.BETA:  		0,
	Constants.CARDS.GAMMA: 		0,
	Constants.CARDS.DELTA: 		0,
	Constants.CARDS.EPSILON: 	0,
}

var burned_cards: Dictionary = {
	Constants.CARDS.ALPHA: 		0,
	Constants.CARDS.BETA:  		0,
	Constants.CARDS.GAMMA: 		0,
	Constants.CARDS.DELTA: 		0,
	Constants.CARDS.EPSILON: 	0,
}

var used_cards: Dictionary = {
	Constants.CARDS.ALPHA: 		0,
	Constants.CARDS.BETA:  		0,
	Constants.CARDS.GAMMA: 		0,
	Constants.CARDS.DELTA: 		0,
	Constants.CARDS.EPSILON: 	0,
}

var shopping_cart: Dictionary = {
	Constants.ITEMS.TRIANGLE:  	0,
	Constants.ITEMS.RECTANGLE: 	0,
	Constants.ITEMS.CIRCLE: 	0,
}

var wishlist: Dictionary = {
	Constants.ITEMS.TRIANGLE:  	0,
	Constants.ITEMS.RECTANGLE: 	0,
	Constants.ITEMS.CIRCLE: 	0,
}


func _ready():
	summary_update_draft.connect(_on_summary_update_draft)
	summary_update_burned_cards.connect(_on_summary_update_burned_cards)
	summary_update_used_cards.connect(_on_summary_update_used_cards)
	summary_update_total_items_cost.connect(_on_summary_update_total_items_cost)
	summary_update_shopping_cart.connect(_on_summary_update_shopping_cart)
	summary_update_wishlist.connect(_on_summary_update_wishlist)


func _on_summary_update_draft(cards: Array[Card]):
	for i: int in cards.size():
		starting_deck[cards[i].type] += 1


func _on_summary_update_burned_cards(cards: Array[Card]):
	for i: int in cards.size():
		burned_cards[cards[i].type] += 1


func _on_summary_update_used_cards(cards: Array[Card]):
	for i: int in cards.size():
		used_cards[cards[i].type] += 1


func _on_summary_update_total_items_cost(total_hand_value: int):
	total_items_cost += total_hand_value


func _on_summary_update_shopping_cart(cart: Dictionary):
	shopping_cart[Constants.ITEMS.TRIANGLE] = cart[Constants.ITEMS.TRIANGLE]
	shopping_cart[Constants.ITEMS.RECTANGLE] = cart[Constants.ITEMS.RECTANGLE]
	shopping_cart[Constants.ITEMS.CIRCLE] = cart[Constants.ITEMS.CIRCLE]


func _on_summary_update_wishlist(list: Dictionary):
	wishlist[Constants.ITEMS.TRIANGLE] = list[Constants.ITEMS.TRIANGLE]
	wishlist[Constants.ITEMS.RECTANGLE] = list[Constants.ITEMS.RECTANGLE]
	wishlist[Constants.ITEMS.CIRCLE] = list[Constants.ITEMS.CIRCLE]
