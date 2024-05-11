class_name MarketManager extends Node2D

@export
var DECK: Deck

@onready
var _shelves: Node2D = %Shelves

@onready
var _shopkeeper: Node2D = %Shopkeeper

func _ready():
	print_debug("MARKET READY")
	EventBusGame.deck_empty.connect(_on_deck_empty)

func _on_deck_empty():
	EventBusGame.game_end.emit()
