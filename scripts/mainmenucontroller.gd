extends Control

var start_button : Button
var quit_button : Button

@export var map_size_buttons : ButtonGroup
@export var resource_buttons : ButtonGroup

var menu_container : MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button = get_node("MarginContainer/VBoxContainer/StartGameButton")
	start_button.pressed.connect(start_game)
	
	quit_button = get_node("MarginContainer/VBoxContainer/QuitGameButton")
	quit_button.pressed.connect(get_tree().quit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_game():
	var buttons = map_size_buttons.get_buttons()
	for button in buttons:
		if button is CheckBox and button.button_pressed:
			set_map_size(button.get_meta("MapSize"))
	
	buttons = resource_buttons.get_buttons()
	for button in buttons:
		if button is CheckBox and button.button_pressed:
			set_resource_abundance(button.get_meta("ResourceChance"))
	
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
	
func set_map_size(size : int):
	global.map_size = size
	
	
func set_resource_abundance(percent : float):
	global.resource_abundance = percent
