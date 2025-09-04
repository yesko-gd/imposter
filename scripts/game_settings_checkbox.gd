extends CenterContainer

signal toggled(toggled_on: bool)

func _toggled(toggled_on: bool) -> void:
	toggled.emit(toggled_on)
