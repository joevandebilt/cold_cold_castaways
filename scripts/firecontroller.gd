extends Area2D

var fire_sprite : AnimatedSprite2D
var player : PlayerController

var fuel_available : float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game Scene/Player")
	fire_sprite = get_node("FireSprite")
	
	area_entered.connect(_on_enter)
	area_exited.connect(_on_exit)
	
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	
	fire_sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fuel_available += -0.5 * delta
	fuel_available = clamp(fuel_available, 0, 9999999)
	
	if fuel_available == 0:
		player.setexposure(-1)

func _on_enter(body: Node2D):
	if body is PlayerController:
		print("Setting exposure to positive")
		player.setexposure(1.5)
	
func _on_exit(body: Node2D):
	if body is PlayerController:
		print("Setting exposure to negative")
		player.setexposure(-1)		
		
func addfuel(amount: int):
	fuel_available += amount
	player.setexposure(1.5)
