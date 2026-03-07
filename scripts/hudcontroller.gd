extends CanvasLayer

var exposure_label : Label
var hunger_label : Label
var health_label : Label

var player : PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game Scene/Player")
	
	exposure_label = get_node("Margins/Vbox/ExposureLabel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	exposure_label.text = "Exposure: {0}%".format([round(player.getexposure())])
	
