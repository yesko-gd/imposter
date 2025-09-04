class_name PlayerInfo
extends PanelContainer

signal next()

var _current_player: Player

@onready var _player_name: Label = %PlayerName
@onready var _pass: Button = %Pass

# signals

func _reveal_pressed() -> void:
	_pass.disabled = false

func _pass_pressed() -> void:
	_pass.disabled = true
	next.emit()

# other

func set_current_player(player: Player) -> void:
	_current_player = player

	_set_player_name(player.name_str)

func _set_player_name(value: String) -> void:
	_player_name.text = value
