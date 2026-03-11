class_name FireController

extends Area2D

var fire_sprite : AnimatedSprite2D
var fire_menu : PanelContainer

var player : PlayerController

var add_wood_button : Button

var grab_torch_section: HBoxContainer
var grab_torch_button : Button

var fuelLabel : Label

@export var fuel_available : float = 200
var decay_rate : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game Scene/Camp/Player")
	fire_sprite = get_node("FireSprite")
	fire_menu = get_node("FireMenu")
	
	add_wood_button = get_node("FireMenu/Margins/VBoxContainer/AddFuelButtons/AddWoodButton")
	add_wood_button.pressed.connect(add_fuel.bind(10))
	
	grab_torch_section = get_node("FireMenu/Margins/VBoxContainer/TakeTorchButtons")
	grab_torch_button = get_node("FireMenu/Margins/VBoxContainer/TakeTorchButtons/TakeTorchButton")
	grab_torch_button.pressed.connect(grab_torch)
	
	fuelLabel = get_node("FireMenu/Margins/VBoxContainer/FuelAvailableLabel")
	
	area_entered.connect(_on_enter)
	area_exited.connect(_on_exit)
	
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	
	fire_sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	fuel_available -= decay_rate * delta
	fuel_available = clamp(fuel_available, 0, 9999999)
	
	fuelLabel.text = "Wood on campfire: {0}".format([roundi(fuel_available)])
	
	if fuel_available == 0:
		fire_sprite.animation = "fire_out"
		if player.near_fire and overlaps_body(player):
			player.near_fire = false
	
	if fuel_available < 20:
		grab_torch_section.hide()
	else:
		grab_torch_section.show()

func _on_enter(body: Node2D):
	if body.name == "PlayerInteractions":
		print("Setting exposure to positive")
		_show_menu()
		if fuel_available > 0:
			player.near_fire = true
		
func _on_exit(body: Node2D):
	if body.name == "PlayerInteractions":
		print("Setting exposure to negative")
		player.near_fire = false
		_hide_menu()

func _show_menu():
		fire_menu.show()
		var tween = create_tween()
		tween.tween_property(fire_menu, "scale", Vector2(1,1), 0.2)
		
func _hide_menu():
		var tween = create_tween()
		tween.tween_property(fire_menu, "scale", Vector2(0.2,0.2), 0.2)
		await tween.finished
		fire_menu.hide()

func add_fuel(amount: int):
	var amt = player.inventory.spend_resource(player.inventory.Resources.WOOD, amount)
	fuel_available += amt
	if fire_sprite.animation != "default":
		fire_sprite.animation = "default"
	player.near_fire = true

func grab_torch():
	if fuel_available > 20 and !player.has_torch:
		fuel_available -= 20
		player.grab_torch()
