extends Node

# Draft phase
signal game_new()
# Market phase
signal game_start()
# Results screen
signal game_end(win:bool)

# From market to battle phase
signal battle_start()
# From battle back to market phase
signal battle_end(win: bool)

signal card_select(index: int)
signal draft_card_select(idx: int, selected: bool)
signal battle_card_select(card: Card)

signal item_select(index: int)

signal deck_update(new_cards: Array[Card])
signal shopping_cart_add_item(item: Constants.ITEMS)
signal shopping_cart_remove_item(item: Constants.ITEMS)
signal wishlist_add_item(item: Constants.ITEMS)
signal wishlist_remove_item(item: Constants.ITEMS)
signal wishlist_randomize(items: Dictionary)


signal summary_update_draft(cards: Array[Card])
signal summary_update_burned_cards(cards: Array[Card])
signal summary_update_used_cards(cards: Array[Card])
signal summary_update_total_items_cost(total_hand_value: int)
signal summary_update_shopping_cart(cart: Dictionary)
signal summary_update_wishlist(list: Dictionary)

var total_items_cost: int = 0

var starting_deck: Dictionary = {
	"Alpha": 	{ "value": 1,  "quantity": 0 },
	"Beta":  	{ "value": 5,  "quantity": 0 },
	"Gamma": 	{ "value": 10, "quantity": 0 },
	"Delta": 	{ "value": 20, "quantity": 0 },
	"Epsilon": 	{ "value": 50, "quantity": 0 }
}

var burned_cards: Dictionary = {
	"Alpha": 	{ "value": 1,  "quantity": 0 },
	"Beta":  	{ "value": 5,  "quantity": 0 },
	"Gamma": 	{ "value": 10, "quantity": 0 },
	"Delta": 	{ "value": 20, "quantity": 0 },
	"Epsilon": 	{ "value": 50, "quantity": 0 }
}

var used_cards: Dictionary = {
	"Alpha": 	{ "value": 1,  "quantity": 0 },
	"Beta":  	{ "value": 5,  "quantity": 0 },
	"Gamma": 	{ "value": 10, "quantity": 0 },
	"Delta": 	{ "value": 20, "quantity": 0 },
	"Epsilon": 	{ "value": 50, "quantity": 0 }
}

var shopping_cart: Dictionary = {
	"Triangle":  0,
	"Rectangle": 0,
	"Circle": 	 0
}

var wishlist: Dictionary = {
	"Triangle":  0,
	"Rectangle": 0,
	"Circle": 	 0
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
		starting_deck[cards[i].type]["quantity"] += 1


func _on_summary_update_burned_cards(cards: Array[Card]):
	for i: int in cards.size():
		burned_cards[cards[i].type]["quantity"] += 1


func _on_summary_update_used_cards(cards: Array[Card]):
	for i: int in cards.size():
		used_cards[cards[i].type]["quantity"] += 1


func _on_summary_update_total_items_cost(total_hand_value: int):
	total_items_cost += total_hand_value


func _on_summary_update_shopping_cart(cart: Dictionary):
	shopping_cart["Triangle"] = cart["Triangle"]
	shopping_cart["Rectangle"] = cart["Rectangle"]
	shopping_cart["Circle"] = cart["Circle"]


func _on_summary_update_wishlist(list: Dictionary):
	wishlist["Triangle"] = list["Triangle"]
	wishlist["Rectangle"] = list["Rectangle"]
	wishlist["Circle"] = list["Circle"]
