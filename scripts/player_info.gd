class_name PlayerInfo
extends PanelContainer

signal next()

var _current_player: Player

@onready var _player_name: Label = %PlayerName
@onready var _roll: Label = %Roll
@onready var _word: Label = %Word
@onready var _reveal: Button = %Reveal
@onready var _pass: Button = %Pass

# override

func _process(_delta: float) -> void:
	if not _reveal.button_pressed:
		_hide()

# other

func set_current_player(player: Player) -> void:
	_current_player = player

	_set_player_name(player.name_str)

	var is_imposter: bool = Global.imposters.has(player)
	_roll.text = "Imposter" if is_imposter else "Unschuldig"
	_word.text = Global.hint if is_imposter else Global.word

	_roll.hide()
	_word.hide()

func _set_player_name(value: String) -> void:
	_player_name.text = value

func _show() -> void:
	_roll.show()
	_word.show()

func _hide() -> void:
	_roll.hide()
	_word.hide()

# - signals

func _reveal_pressed() -> void:
	_show()

	_pass.disabled = false

func _pass_pressed() -> void:
	_pass.disabled = true
	next.emit()
