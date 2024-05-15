class_name Summary extends CenterContainer

const TEXTURE_MAN_WIN = preload("res://assets/graphics/shopkeeper-surprised.png")
const TEXTURE_MAN_LOSE = preload("res://assets/graphics/shopkeeper.png")

var win: bool = false


func _ready():
	var shopping_cart: Dictionary = EventBusGame.shopping_cart
	var wishlist: Dictionary = EventBusGame.wishlist
	var starting_deck: Dictionary = EventBusGame.starting_deck
	var burned_cards: Dictionary = EventBusGame.burned_cards
	var used_cards: Dictionary = EventBusGame.used_cards
	var total_items_cost: int = EventBusGame.total_items_cost

	# Calculate initial budget
	var budget: int = 0
	for key in starting_deck.keys():
		budget += Constants.CARD_VALUES[key] * starting_deck[key]

	# Win/lose results
	if win:#budget == total_items_cost:
		%GameOverText.text = "How did you do it?\nLife surprises me every time. Ha!"
		%LaughText.text = "HUH ????"
		%ManTexture.texture = TEXTURE_MAN_WIN
	else:
		%GameOverText.text = "End of the line, kiddo.\nYou need more money to beat me!"
		%LaughText.text = "AHAHAH"
		%ManTexture.texture = TEXTURE_MAN_LOSE

	# Shopping cart
	%TriangleCart.text = "%d" % shopping_cart[Constants.ITEMS.TRIANGLE]
	%RectangleCart.text = "%d" % shopping_cart[Constants.ITEMS.RECTANGLE]
	%CircleCart.text = "%d" % shopping_cart[Constants.ITEMS.CIRCLE]

	# Wishlist
	%TriangleWishlist.text = "%d" % wishlist[Constants.ITEMS.TRIANGLE]
	%RectangleWishlist.text = "%d" % wishlist[Constants.ITEMS.RECTANGLE]
	%CircleWishlist.text = "%d" % wishlist[Constants.ITEMS.CIRCLE]

	# Cards played
	%BillSpent1.text = "%d" % used_cards[Constants.CARDS.ALPHA]
	%BillSpent5.text = "%d" % used_cards[Constants.CARDS.BETA]
	%BillSpent10.text = "%d" % used_cards[Constants.CARDS.GAMMA]
	%BillSpent20.text = "%d" % used_cards[Constants.CARDS.DELTA]
	%BillSpent50.text = "%d" % used_cards[Constants.CARDS.EPSILON]

	# Cards burned
	%BillBurned1.text = "%d" % burned_cards[Constants.CARDS.ALPHA]
	%BillBurned5.text = "%d" % burned_cards[Constants.CARDS.BETA]
	%BillBurned10.text = "%d" % burned_cards[Constants.CARDS.GAMMA]
	%BillBurned20.text = "%d" % burned_cards[Constants.CARDS.DELTA]
	%BillBurned50.text = "%d" % burned_cards[Constants.CARDS.EPSILON]

	# Total items cost
	%PriceGoalValue.text = "%d$" % total_items_cost

	# Initial budget
	%StartingBudgetValue.text = "%d$" % budget


func _on_restart_button_pressed() -> void:
	EventBusGame.game_new.emit()
