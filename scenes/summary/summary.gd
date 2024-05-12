class_name Summary extends CenterContainer

var TEXTURE_MAN_WIN = preload("res://assets/graphics/shopkeeper-surprised.png")
var TEXTURE_MAN_LOSE = preload("res://assets/graphics/shopkeeper.png")

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
		budget += starting_deck[key]["value"] * starting_deck[key]["quantity"]

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
	%TriangleCart.text = "%d" % shopping_cart["Triangle"]
	%RectangleCart.text = "%d" % shopping_cart["Rectangle"]
	%CircleCart.text = "%d" % shopping_cart["Circle"]

	# Wishlist
	%TriangleWishlist.text = "%d" % wishlist["Triangle"]
	%RectangleWishlist.text = "%d" % wishlist["Rectangle"]
	%CircleWishlist.text = "%d" % wishlist["Circle"]

	# Cards played
	%BillSpent1.text = "%d" % used_cards["Alpha"]["quantity"]
	%BillSpent5.text = "%d" % used_cards["Beta"]["quantity"]
	%BillSpent10.text = "%d" % used_cards["Gamma"]["quantity"]
	%BillSpent20.text = "%d" % used_cards["Delta"]["quantity"]
	%BillSpent50.text = "%d" % used_cards["Epsilon"]["quantity"]

	# Cards burned
	%BillBurned1.text = "%d" % burned_cards["Alpha"]["quantity"]
	%BillBurned5.text = "%d" % burned_cards["Beta"]["quantity"]
	%BillBurned10.text = "%d" % burned_cards["Gamma"]["quantity"]
	%BillBurned20.text = "%d" % burned_cards["Delta"]["quantity"]
	%BillBurned50.text = "%d" % burned_cards["Epsilon"]["quantity"]

	# Total items cost
	%PriceGoalValue.text = "%d$" % total_items_cost

	# Initial budget
	%StartingBudgetValue.text = "%d$" % budget
