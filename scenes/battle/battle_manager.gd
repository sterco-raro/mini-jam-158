class_name BattleManager extends Node2D

const CARDS: Dictionary = {
	"Alpha": 	{ "value": 1,  "quantity": 0 },
	"Beta": 	{ "value": 5,  "quantity": 0 },
	"Gamma": 	{ "value": 10, "quantity": 0 },
	"Delta": 	{ "value": 20, "quantity": 0 },
	"Epsilon": 	{ "value": 50, "quantity": 0 },
}

var player_hand: Dictionary
var shopkeeper_hand: Dictionary

@export
var available_changes: int = 2

var DECK: Deck

func _init_battle():
	pass
