class_name __Manager__
extends Control

signal finished_setup()
signal swapped(to: RootChild)

const info_path := "info.json"
const maps_path := "data/maps.json"
const settings_path := "data/settings.json"

const required_info_elements: Array[String] = [
	"version"
]
const required_maps_sections: Array[String] = [
	"key",
	"mouse_button"
]
const required_settings_sections: Array[String] = [
	"constants",
	"settings",
	"keybinds",
	"shortcuts"
]

var _info: Dictionary[String, Variant] = {}
var _maps: Dictionary[String, Dictionary] = {}
var _settings: Dictionary[String, Dictionary] = {}
## shortcuts represent methods of current_child
var _shortcuts: Dictionary[String, Dictionary]

var _actions: Array[String] = []

@onready var root: Window = get_tree().root
var current_child: RootChild

var setup_finished: bool = false

func swap(to: PackedScene) -> void:
	current_child.queue_free()
	var to_node: Node = to.instantiate()

	if not to_node is RootChild:
		push_error("Parameter 'to' has to instantiate to type 'RootChild'")
		return

	var to_root_child := to_node as RootChild

	root.add_child(to_root_child)
	current_child = to_root_child

	setup_current_child()

	swapped.emit(to_root_child)

func setup_current_child() -> void:
	root.move_child.call_deferred(current_child, 0)

	current_child.show_behind_parent = true

	reload_shortcuts()

func _ready() -> void:
	reload_data()

	current_child = root.get_child(root.get_child_count() - 1)
	setup_current_child()

	setup_finished = true
	finished_setup.emit()

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	for shortcut: String in _shortcuts.keys():
		var shortcut_dict: Dictionary[String, String] = {}
		shortcut_dict.assign(_shortcuts[shortcut])

		if shortcut_dict.modifier != "" and not Input.is_key_pressed(maps("key", shortcut_dict.modifier)):
			continue

		var pressed: bool = false
		if Input.is_key_pressed(maps("key", shortcut_dict.key)): # key
			pressed = true
		elif shortcut_dict.alt_key != "" and Input.is_key_pressed(maps("key", shortcut_dict.alt_key)): # alternative key
			pressed = true
		if not pressed:
			continue

		current_child.call(shortcut)

func constants(key: String) -> Variant:
	if not _settings.constants.has(key):
		push_error("Invalid key '%s' in constants" % key)
		return null

	return _settings.constants[key]

func info(key: String) -> Variant:
	if not _info.has(key):
		push_error("Invalid key '%s' in info" % key)
		return null

	return _info[key]

func settings(key: String) -> Variant:
	if not _settings.settings.has(key):
		push_error("Invalid key '%s' in settings" % key)
		return null

	return _settings.settings[key]

func maps(section: String, key: String) -> Variant:
	if not _maps.has(section):
		push_error("Section '%s' not found in '%s'" % [section, maps_path])
		return null
	if not _maps[section].has(key):
		push_error("Key '%s' not found in '%s::%s'" % [key, maps_path, section])
		return null
	return _maps[section][key]

func maps_section(section: String) -> Dictionary:
	if not _maps.has(section):
		push_error("Section '%s' not found in '%s'" % [section , maps_path])
		return {}
	return _maps[section]

func reload_data() -> void:
	parse_info()
	parse_maps()
	parse_settings()
	reload_inputs()

func parse_info_keep() -> void:
	if _info.size() == 0:
		parse_info()

func parse_info() -> void:
	_info.assign(parse_json(info_path))
	if _info.size() == 0:
		push_error("Error loading/parsing '%s'" % info_path)
		return

	for element in required_info_elements:
		if not _info.has(element):
			push_error("'%s' is missing section '%s'" % [info_path, element])

func parse_maps_keep() -> void:
	if _maps.size() == 0:
		parse_maps()

func parse_maps() -> void:
	_maps.assign(parse_json(maps_path))
	if _maps.size() == 0:
		push_error("Error loading/parsing '%s'" % maps_path)
		return

	for section in required_maps_sections:
		if not _maps.has(section):
			push_error("'%s' is missing section '%s'" % [maps_path, section])

func parse_settings_keep() -> void:
	if _settings.size() == 0:
		parse_settings()

func parse_settings() -> void:
	_settings.assign(parse_json(settings_path))
	if _settings.size() == 0:
		push_error("Error loading/parsing '%s'" % settings_path)
		return

	for section in required_settings_sections:
		if not _settings.has(section):
			push_error("'%s' is missing section '%s'" % [settings_path, section])

func reload_inputs() -> void:
	parse_settings_keep()
	clear_inputs()
	load_inputs()

func reload_shortcuts() -> void:
	parse_settings_keep()

	var all_methods: Array[String] = []
	for method in current_child.get_script().get_script_method_list():
		all_methods.push_back(method.name)

	for shortcut: String in _settings.shortcuts.keys():
		if not all_methods.has(shortcut):
			push_error("Unknown function '%s' in '%s'" % [shortcut, current_child.get_script().get_global_name()])
			return

		var shortcut_dict: Dictionary[String, String] = {}
		shortcut_dict.assign(_settings.shortcuts[shortcut])

		var modifier: String = shortcut_dict.modifier
		if modifier != "" and not _maps.key.has(modifier):
			push_error("Modifier '%s' not found in '%s::key'" % [modifier, maps_path])
			return

		var key: String = shortcut_dict.key
		if not _maps.key.has(key):
			push_error("Key '%s' not found in '%s::key'" % [key, maps_path])
			return

		var alt_key: String = shortcut_dict.key
		if alt_key != "" and not _maps.key.has(alt_key):
			push_error("Alternative key '%s' not found in '%s::key'" % [key, maps_path])
			return

	_shortcuts.assign(_settings.shortcuts)

func clear_inputs() -> void:
	for action in _actions:
		InputMap.erase_action(action)
	_actions.clear()

func load_inputs() -> void:
	for action_name: String in _settings.keybinds:
		add_input(action_name, _settings.keybinds[action_name])

func add_input(action_name: String, event_name: String) -> void:
	if InputMap.has_action(action_name):
		push_error("Action '%s' already exists" % action_name)
		return

	var event := input_event(event_name)

	if event == null:
		push_error("Error retreiving code for event name '%s'" % event_name)
		return

	InputMap.add_action(action_name)
	InputMap.action_add_event(action_name, event)

#	generic

func expand_array_dict(what: Dictionary, dict_key: Variant, array_size: int) -> void:
	if not what.has(dict_key):
		what[dict_key] = []
	if what[dict_key].size() < array_size:
		what[dict_key].resize(array_size)

func parse_json(path: String) -> Dictionary[String, Variant]:
	var file := FileAccess.open(path, FileAccess.READ)

	if file == null:
		push_error("Failed to open file '%s'" % path)
		return {}

	var parsed: Variant = JSON.parse_string(file.get_as_text())

	if parsed == null:
		push_error("Failed to parse json at '%s'" % path)
		return {}

	var json: Dictionary[String, Variant] = {}
	json.assign(parsed)

	return json

func input_event(event_name: String) -> InputEvent:
	if _maps.key.has(event_name):
		var event := InputEventKey.new()
		event.keycode = _maps.key[event_name]
		return event
	if _maps.mouse_button.has(event_name):
		var event := InputEventMouseButton.new()
		event.button_index = _maps.mouse_button[event_name]
		return event

	push_error("Unknown event name '%s'" % event_name)
	return null
