extends Control

var start_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button = get_node("PanelContainer/MarginContainer/VBoxContainer/StartGameButton")
	start_button.pressed.connect(start_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_game():
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
