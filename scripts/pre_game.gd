class_name PreGame
extends RootChild

@onready var _player_info: PlayerInfo = %PlayerInfo

func _ready() -> void:
	for player: Player in Global.players:
		_player_info.set_current_player(player)
		await _player_info.next

	Manager.swap(Global.game_scene)
