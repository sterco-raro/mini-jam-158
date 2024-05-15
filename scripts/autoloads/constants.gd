extends Node

enum CARDS {
	ALPHA,
	BETA,
	GAMMA,
	DELTA,
	EPSILON
}

enum ITEMS {
	CIRCLE,
	RECTANGLE,
	TRIANGLE,
}

const DECK_INITIAL_SIZE: int = 6
const DECK_MAX_CARDS: int = 16

const PREFAB_CARDS: Dictionary = {
	CARDS.ALPHA: 	preload("res://scenes/cards/card_alpha.tscn"),
	CARDS.BETA: 	preload("res://scenes/cards/card_beta.tscn"),
	CARDS.GAMMA: 	preload("res://scenes/cards/card_gamma.tscn"),
	CARDS.DELTA: 	preload("res://scenes/cards/card_delta.tscn"),
	CARDS.EPSILON: 	preload("res://scenes/cards/card_epsilon.tscn")
}

const PREFAB_ITEMS: Dictionary = {
	Constants.ITEMS.TRIANGLE: 	preload("res://scenes/items/item_triangle.tscn"),
	Constants.ITEMS.RECTANGLE: 	preload("res://scenes/items/item_rectangle.tscn"),
	Constants.ITEMS.CIRCLE: 	preload("res://scenes/items/item_circle.tscn"),
}

const CARD_VALUES: Dictionary = {
	CARDS.ALPHA: 	1,
	CARDS.BETA: 	5,
	CARDS.GAMMA: 	10,
	CARDS.DELTA: 	20,
	CARDS.EPSILON: 	50,
}
