extends Control

var quit_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quit_button.get_node("PanelContainer/MarginContainer/VBoxContainer/QuitButton")
	quit_button.pressed.connect(_quit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _quit():
	get_tree().quit()
