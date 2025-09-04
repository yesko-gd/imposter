class_name GameRoot
extends RootChild

const IMPOSTER_TEXT: String = "Die Imposter sind:\n[b]%s[/b]"

@onready var _main_menu_scene: PackedScene = load("res://scenes/main_menu.tscn") # load instead of preload because of cyclic dependency

@onready var _game_ui: Control = %GameUI
@onready var _post_game_ui: Control = %PostGameUI
@onready var _timer: Label = %Timer
@onready var _starting_player: Label = %StartingPlayer
@onready var _pause: Control = %Pause
@onready var _alt_pause: Control = %AltPause
@onready var _imposter: RichTextLabel = %Imposter

var _time_left: float = 0.0
var _paused: bool = false

# signals

func _pause_pressed() -> void:
	set_paused(true)

func _reveal_pressed() -> void:
	end_game()

func _unpause_pressed() -> void:
	set_paused(false)

func _new_game() -> void:
	Manager.swap(_main_menu_scene)
	(Manager.current_child as MainMenu).play()

# other

func set_paused(value: bool) -> void:
	_paused = value
	_pause.visible = not value
	_alt_pause.visible = value

func end_game() -> void:
	_game_ui.visible = false
	_post_game_ui.visible = true

	var imposter_list: String = ""
	for imposter: Player in Global.imposters:
		imposter_list += imposter.name_str + "\n"

	_imposter.text = IMPOSTER_TEXT % imposter_list

func _ready() -> void:
	_start_timer()

	var player_name: String = Global.players[randi() % Global.players.size()].name_str
	_starting_player.text = "%s beginnt!" % player_name

func _process(delta: float) -> void:
	if not _paused:
		_time_left -= delta

	if _time_left <= 0:
		_time_left = 0
		return

	var second_str := str(int(_time_left) % 60)
	if second_str.length() < 2:
		second_str = second_str.insert(0, "0")
	_timer.text = "%d:%s" % [floor(_time_left / 60), second_str]

func _start_timer() -> void:
	_time_left = 60 * Global.time_limit
