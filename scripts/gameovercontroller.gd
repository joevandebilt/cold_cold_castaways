extends Control

var quit_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quit_button = get_node("PanelContainer/MarginContainer/VBoxContainer/QuitButton")
	quit_button.pressed.connect(_quit)

func _quit():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
