class_name PlayerController

extends CharacterBody2D

@export var Speed : int = 200

#Child nodes
var player_sprite : AnimatedSprite2D
var interaction_radius : Area2D

#Player Properties
var health : float = 100
var exposure : float = 100
var hunger: float = 100

var near_fire = false
var has_torch = false

#Inventory
var inventory : Inventory

#Sibling Nodes
var fire_controller : FireController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = Inventory.new()
	
	player_sprite = get_node("PlayerSprite")
	player_sprite.play()
	
	interaction_radius = get_node("PlayerInteractions")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("action"):
		_try_interact()
		
	if Input.is_action_just_released("pause"):
		pass
	
	var exposure_delta = -0.5	# * weather.get_extremity()
	var health_delta = 0
	var hunger_delta = 0.3
	
	if has_torch:
		exposure_delta = 0
	if near_fire:
		exposure_delta = 1.5
	
	if exposure == 0:
		health_delta = -0.75
		
	#if near_doctor:
		#health_delta = 1.5
	
	exposure += exposure_delta * delta
	health += health_delta * delta
	hunger += hunger_delta * delta
	
	exposure = clamp(exposure, 0, 100)
	health = clamp(health, 0, 100)
	hunger = clamp(hunger, 0, 100)
		
	if health == 0:
		print("Game Over!!")
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	var animation = "default"
	if Input.is_action_pressed("move_up"):
		animation = "walk_away"
		direction.y += -1
	if Input.is_action_pressed("move_down"):
		direction .y += 1
		animation = "walk_towards"
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		animation = "walk_left_right"
		player_sprite.flip_h = true
	if Input.is_action_pressed("move_left"):
		direction.x += -1
		animation = "walk_left_right"
		player_sprite.flip_h = false
	
	if has_torch:
		player_sprite.animation = "torch_{0}".format([animation])
	else:
		player_sprite.animation = animation
	
	velocity = direction.normalized() * Speed	
	move_and_slide()

func _try_interact() -> void:
	var interactions = interaction_radius.get_overlapping_areas()
	
	for interaction in interactions:
		if interaction.has_method("interact"):
			interaction.interact()
	
func get_exposure() -> float:
	return exposure
	
func get_health() -> float:
	return health
	
func get_hunger() -> float:
	return hunger

func eat_food():
	var amt = inventory.spend_resource(inventory.Resources.FOOD, 5)
	hunger += amt
	
func grab_torch():
	has_torch = true
	
	var timer = Timer.new()
	add_child(timer)
	
	timer.start(60)
	timer.timeout.connect(drop_torch)
	
func drop_torch():
	has_torch = false
