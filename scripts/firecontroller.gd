class_name FireController

extends Area2D

var fire_sprite : AnimatedSprite2D
var fire_menu : PanelContainer

var player : PlayerController

var add1button : TextureButton
var add10button : TextureButton
var add100button : TextureButton

var grab_torch_button : Button

var fuelLabel : Label

@export var fuel_available : float = 200
var decay_rate : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game Scene/Camp/Player")
	fire_sprite = get_node("FireSprite")
	fire_menu = get_node("FireMenu")
	
	add1button = get_node("FireMenu/Margins/VBoxContainer/AddFuelButtons/Add1FuelButton")
	add10button = get_node("FireMenu/Margins/VBoxContainer/AddFuelButtons/Add10FuelButton")
	add100button = get_node("FireMenu/Margins/VBoxContainer/AddFuelButtons/Add100FuelButton")
	
	add1button.pressed.connect(add_fuel.bind(1))
	add10button.pressed.connect(add_fuel.bind(10))
	add100button.pressed.connect(add_fuel.bind(100))
	
	grab_torch_button = get_node("FireMenu/Margins/VBoxContainer/HBoxContainer/TakeTorchButton")
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
	
	fuelLabel.text = "Wood Available: {0}".format([roundi(fuel_available)])
	
	if fuel_available == 0:
		fire_sprite.animation = "fire_out"
		player.near_fire = false

func _on_enter(body: Node2D):
	if body is PlayerController:
		print("Setting exposure to positive")
		player.near_fire = true
		_show_menu()
		
func _on_exit(body: Node2D):
	if body is PlayerController:
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
