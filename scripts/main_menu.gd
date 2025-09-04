class_name MainMenu
extends RootChild

const _game_settings_player_scene: PackedScene = preload("res://scenes/game_settings_player.tscn")

@onready var home_group: Control = %Home
@onready var game_settings_group: Control = %GameSettings

@onready var player_parent: Control = %PlayerParent

var imposter_count: int = -1

var imposter_count_set: bool = false
var time_limit_set: bool = false
var imposter_hint_set: bool = false

func play() -> void:
	home_group.hide()
	game_settings_group.show()

func _start() -> void:
	if not time_limit_set:
		return
	if not imposter_count_set:
		return
	#if not imposter_hint_set: 
		#return

	var players: Array[Player] = Global.players
	var imposters: Array[Player] = []
	Global.imposters.clear()

	if imposter_count >= players.size():
		return

	for i in range(imposter_count):
		var new_imposter_index: int = randi() % players.size()
		var new_imposter: Player = players[new_imposter_index]

		if imposters.has(new_imposter):
			i -= 1
			continue

		imposters.push_back(new_imposter)

	Global.imposters = imposters

	var words: Array[String] = []
	words.assign(Manager.constants("words"))
	var hints: Array[String] = []
	hints.assign(Manager.constants("hints"))

	var word_index: int = randi() % words.size()

	Global.word = words[word_index]
	Global.hint = hints[word_index]

	Manager.swap(Global.pre_game_scene)

func add_player(player_name: String = "", add_to_list: bool = true) -> void:
	var player := Player.new()
	if add_to_list:
		Global.players.push_back(player)

	if player_name != "":
		player.name_str = player_name

	var game_settings_player: GameSettingsPlayer = _game_settings_player_scene.instantiate()
	player_parent.add_child(game_settings_player)

	game_settings_player.set_player(player)

func _set_time_limit(new: String) -> void:
	Global.time_limit = new.to_int()
	time_limit_set = true

func _set_imposter_count(new: String) -> void:
	imposter_count = new.to_int()
	imposter_count_set = true

func _set_imposter_hint(new: bool) -> void:
	Global.imposter_hint = new
	imposter_hint_set = true

func _ready() -> void:
	for player: Player in Global.players:
		add_player(player.name_str, false)
