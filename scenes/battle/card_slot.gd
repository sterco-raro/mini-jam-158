class_name CardSlot extends Node2D

@export
var PLAYER_OWNED: bool = false

var card: Card

@onready
var _container: Node2D = $Container

@onready
var _click_cooldown: Timer = $ClickCooldown

var _original_position: Vector2
var _tween_target_position: Vector2

var selected: bool = false

func _ready():
	_original_position = _container.position
	_tween_target_position = _container.position + Vector2.UP * 32

func add_card(_card: Card):
	card = _card
	_container.add_child(card)

func remove_card():
	var _card: Card = card
	if _card:
		_container.remove_child(_card)
	card = null
	return _card

func _on_area_2d_mouse_entered():
	if !PLAYER_OWNED or !card or selected:
		return
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_container, "position", _tween_target_position, 0.2)

func _on_area_2d_mouse_exited():
	if !PLAYER_OWNED or !card or selected:
		return
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_container, "position", _original_position, 0.2)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if !card:
		return
	if !_click_cooldown.is_stopped():
		return
	if event is InputEventMouseButton:
		EventBusGame.battle_card_select.emit(card)
		selected = not selected
		_click_cooldown.start()
