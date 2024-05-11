class_name Card extends Node2D

@export
var type: String = ""

@export
var value: int = 0

@export
var index: int = 0

const DEFAULT_MODULATE = Color(1, 1, 1, 1)
const DEFAULT_SCALE = Vector2.ONE
const HIGHLIGH_MODULATE = Color(1, 1, 1, 0.95)
const HIGHLIGHT_SCALE = Vector2(1.2, 1.2)

@onready
var _click_timer: Timer = $ClickTimer

var _selection_sprite: Sprite2D
var _selected: bool = false

func _ready():
	assert(type != "", "Card type is empty")
	assert(value != 0, "Card value is zero")

	EventBusGame.draft_card_select.connect(_on_draft_card_select)

	_selection_sprite = $Selection
	_selection_sprite.visible = false
	_selection_sprite.modulate.a = 0.4

func _on_area_2d_mouse_entered():
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property($Sprite2D, "modulate", HIGHLIGH_MODULATE, 0.2)
	tween.tween_property($Sprite2D, "scale", HIGHLIGHT_SCALE, 0.2)
	tween.tween_property(_selection_sprite, "scale", HIGHLIGHT_SCALE, 0.2)

func _on_area_2d_mouse_exited():
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property($Sprite2D, "modulate", DEFAULT_MODULATE, 0.2)
	tween.tween_property($Sprite2D, "scale", DEFAULT_SCALE, 0.2)
	tween.tween_property(_selection_sprite, "scale", DEFAULT_SCALE, 0.2)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if !_click_timer.is_stopped():
		return

	if event is InputEventMouseButton:
		EventBusGame.card_select.emit(index)
		_click_timer.start()

func _on_draft_card_select(idx: int, selected: bool):
	if idx == index:
		_selected = selected
		_selection_sprite.visible = _selected
