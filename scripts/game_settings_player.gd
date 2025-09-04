class_name GameSettingsPlayer
extends Control

@onready var _line_edit: LineEdit = %LineEdit

var player: Player

func _set_name(new: String) -> void:
	player.name_str = new

func set_player(value: Player) -> void:
	player = value
	_line_edit.text = value.name_str
