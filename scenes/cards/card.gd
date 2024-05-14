class_name Card extends Node2D

const DEFAULT_MODULATE = Color(1, 1, 1, 1)
const DEFAULT_SCALE = Vector2.ONE
const HIGHLIGH_MODULATE = Color(1, 1, 1, 0.95)
const HIGHLIGHT_SCALE = Vector2(1.2, 1.2)

@export
var type: Constants.CARDS
@export
var value: int = 0
@export
var index: int = 0
@export
var disable_tweens: bool = false

var _selection_sprite: Sprite2D
var _selected: bool = false

@onready
var _click_timer: Timer = $ClickTimer


func _ready():
	assert(type != null, "Card type is null")
	assert(value != 0, "Card value is zero")

	EventBusGame.draft_card_select.connect(_on_draft_card_select)

	_selection_sprite = $Selection
	_selection_sprite.visible = false
	_selection_sprite.modulate.a = 0.4

func _on_area_2d_mouse_entered():
	if disable_tweens:
		return
	var tween = get_tree().create_tween()
	tween.set_parallel().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Sprite2D, "modulate", HIGHLIGH_MODULATE, 0.2)
	tween.tween_property($Sprite2D, "scale", HIGHLIGHT_SCALE, 0.2)
	tween.tween_property(_selection_sprite, "scale", HIGHLIGHT_SCALE, 0.2)

func _on_area_2d_mouse_exited():
	if disable_tweens:
		return
	var tween = get_tree().create_tween()
	tween.set_parallel().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Sprite2D, "modulate", DEFAULT_MODULATE, 0.2)
	tween.tween_property($Sprite2D, "scale", DEFAULT_SCALE, 0.2)
	tween.tween_property(_selection_sprite, "scale", DEFAULT_SCALE, 0.2)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if disable_tweens:
		return
	if !_click_timer.is_stopped():
		return

	if event is InputEventMouseButton:
		EventBusGame.card_select.emit(index)
		_click_timer.start()

func _on_draft_card_select(idx: int, selected: bool):
	if idx == index:
		_selected = selected
		_selection_sprite.visible = _selected
