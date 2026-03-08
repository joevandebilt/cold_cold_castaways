class_name LogController

extends Area2D

var log_sprite : AnimatedSprite2D

var wood_value : int = 3 

var player : PlayerController

# Called when the node enters the scene log for the first time.
func _ready() -> void:
	log_sprite = get_node("LogSprite")
	
	player = get_node("/root/Game Scene/Camp/Player")
	
func interact():
	player.inventory.add_resource(player.inventory.Resources.WOOD, wood_value)
	queue_free()
	
