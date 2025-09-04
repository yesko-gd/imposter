class_name __GlobalClass__
extends Node

const main_menu_scene: PackedScene = preload("res://scenes/main_menu.tscn")
const pre_game_scene: PackedScene = preload("res://scenes/pre_game.tscn")
const game_scene: PackedScene = preload("res://scenes/game.tscn")

var players: Array[Player]
var imposters: Array[Player]

var time_limit: int
var imposter_hint: bool

var word: String
var hint: String
