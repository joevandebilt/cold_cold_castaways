class_name PlayerController

extends Area2D

@export var Speed : int = 200

var player_sprite : AnimatedSprite2D

var health : float = 100
var exposure : float = 100
var hunger: float = 100

var health_delta : float = 0
var exposure_delta : float = 0
var hunger_delta : float = -0.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_sprite = get_node("PlayerSprite")
	player_sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var velocity = Vector2(0,0)
	if Input.is_action_pressed("move_up"):
		player_sprite.animation = "walk_away"
		velocity.y += -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		player_sprite.animation = "walk_towards"
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		player_sprite.animation = "walk_left_right"
		player_sprite.flip_h = true
	if Input.is_action_pressed("move_left"):
		velocity.x += -1
		player_sprite.animation = "walk_left_right"
		player_sprite.flip_h = false
	
			
	if velocity.length() > 0:
		position += velocity.normalized() * delta * Speed
	else:
		player_sprite.animation = "default"
	
	if Input.is_action_pressed("action"):
		pass 
		
	if Input.is_action_pressed("pause"):
		pass
		
	exposure += exposure_delta * delta
	health += health_delta * delta
	hunger += hunger_delta * delta
	
	exposure = clamp(exposure, 0, 100)
	health = clamp(health * delta, 0, 100)
	hunger = clamp(hunger * delta, 0, 100)
	
	if exposure == 0:
		sethealth(health_delta - 1)
		
func setexposure(delta: float):
	exposure_delta = clamp(delta, -5, 5)
	
func sethealth(delta: float):
	health_delta = clamp(delta, -5, 5)
	
func sethunger(delta: float):
	health_delta = clamp(delta, -5, 5)
	
func getexposure() -> float:
	return exposure
