@tool
class_name GameSettingsCheckbox
extends CenterContainer

signal toggled(toggled_on: bool)

@export var disabled: bool = false
@export var check_box: CheckBox

func _process(_delta: float) -> void:
	if check_box != null:
		check_box.disabled = disabled

func _toggled(toggled_on: bool) -> void:
	toggled.emit(toggled_on)
