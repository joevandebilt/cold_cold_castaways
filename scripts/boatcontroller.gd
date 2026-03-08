class_name BoatController

extends Area2D

#Child Nodes
var boat_menu : PanelContainer

#Labels
var wood_needed_label : Label
var food_needed_label : Label
var rope_needed_label : Label
var medecine_needed_label : Label
var coats_needed_label : Label

#Buttons
var add_wood_1 : TextureButton
var add_wood_10 : TextureButton
var add_wood_100 : TextureButton
var add_food_1 : TextureButton
var add_food_10 : TextureButton
var add_food_100 : TextureButton
var add_rope_1 : TextureButton
var add_rope_10 : TextureButton
var add_rope_100 : TextureButton
var add_meds_1 : TextureButton
var add_meds_10 : TextureButton
var add_coats_1 : TextureButton

#Sibling Nodes
var player : PlayerController

#Boat Properties
var wood_needed : int = 5000
var food_needed : int = 2000
var rope_needed : int = 100
var medecine_needed : int = 50
var coats_needed: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game Scene/Camp/Player")
	
	boat_menu = get_node("BoatMenu")
	
	wood_needed_label = get_node("BoatMenu/Margins/VBoxContainer/WoodNeededLabel")
	food_needed_label = get_node("BoatMenu/Margins/VBoxContainer/FoodNeededLabel")
	rope_needed_label = get_node("BoatMenu/Margins/VBoxContainer/RopeNeededLabel")
	medecine_needed_label = get_node("BoatMenu/Margins/VBoxContainer/MedecineNeededLabel")
	coats_needed_label = get_node("BoatMenu/Margins/VBoxContainer/CoatsNeededLabel")

	add_wood_1 = get_node("BoatMenu/Margins/VBoxContainer/AddWoodButtons/Add1WoodButton")
	add_wood_10 = get_node("BoatMenu/Margins/VBoxContainer/AddWoodButtons/Add10WoodButton")
	add_wood_100 = get_node("BoatMenu/Margins/VBoxContainer/AddWoodButtons/Add100WoodButton")

	add_wood_1.pressed.connect(add_wood.bind(1))
	add_wood_10.pressed.connect(add_wood.bind(10))
	add_wood_100.pressed.connect(add_wood.bind(100))
	
	add_food_1 = get_node("BoatMenu/Margins/VBoxContainer/AddFoodButtons/Add1FoodButton")
	add_food_10 = get_node("BoatMenu/Margins/VBoxContainer/AddFoodButtons/Add10FoodButton")
	add_food_100 = get_node("BoatMenu/Margins/VBoxContainer/AddFoodButtons/Add100FoodButton")
		
	add_food_1.pressed.connect(add_food.bind(1))
	add_food_10.pressed.connect(add_food.bind(10))
	add_food_100.pressed.connect(add_food.bind(100))
	
	add_rope_1 = get_node("BoatMenu/Margins/VBoxContainer/AddRopeButtons/Add1RopeButton")
	add_rope_10 = get_node("BoatMenu/Margins/VBoxContainer/AddRopeButtons/Add10RopeButton")
	add_rope_100 = get_node("BoatMenu/Margins/VBoxContainer/AddRopeButtons/Add100RopeButton")
		
	add_rope_1.pressed.connect(add_rope.bind(1))
	add_rope_10.pressed.connect(add_rope.bind(10))
	add_rope_100.pressed.connect(add_rope.bind(100))
	
	add_meds_1 = get_node("BoatMenu/Margins/VBoxContainer/AddMedsButtons/Add1MedsButton")
	add_meds_10 = get_node("BoatMenu/Margins/VBoxContainer/AddMedsButtons/Add10MedsButton")

	add_meds_1.pressed.connect(add_meds.bind(1))
	add_meds_10.pressed.connect(add_meds.bind(10))
	
	add_coats_1 = get_node("BoatMenu/Margins/VBoxContainer/AddCoatsButtons/AddCoatButton")
	add_coats_1.pressed.connect(add_coats.bind(1))
	
	area_entered.connect(_on_enter)
	area_exited.connect(_on_exit)
	
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wood_needed_label.text = "Wood Needed: {0}".format([wood_needed])
	food_needed_label.text = "Food Needed: {0}".format([food_needed])
	rope_needed_label.text = "Rope Needed: {0}".format([rope_needed])
	medecine_needed_label.text = "Medecine Needed: {0}".format([medecine_needed])
	coats_needed_label.text = "Coats Needed: {0}".format([coats_needed])
	
	if wood_needed <= 0 and \
	food_needed <=0 and \
	rope_needed <= 0 and \
	medecine_needed <= 0 and \
	coats_needed <=0:
		get_tree().change_scene_to_file("res://scenes/game_won.tscn")
	
func _on_enter(body: Node2D):
	if body is PlayerController:
		_show_menu()

func _on_exit(body: Node2D):
	if body is PlayerController:
		_hide_menu()

func _show_menu():
		boat_menu.show()
		var tween = create_tween()
		tween.tween_property(boat_menu, "scale", Vector2(1,1), 0.2)
		
func _hide_menu():
		var tween = create_tween()
		tween.tween_property(boat_menu, "scale", Vector2(0.2,0.2), 0.2)
		await tween.finished
		boat_menu.hide()
		
func add_wood(amount: int):
	if wood_needed < amount:
		amount = wood_needed
	var amt = player.inventory.spend_resource(player.inventory.Resources.WOOD, amount)
	wood_needed -= amt
	wood_needed = clamp(wood_needed, 0, 99999)

func add_food(amount: int):
	if food_needed < amount:
		amount = food_needed
	var amt = player.inventory.spend_resource(player.inventory.Resources.FOOD, amount)
	food_needed -= amt
	food_needed = clamp(food_needed, 0, 99999)
	
func add_rope(amount: int):
	if rope_needed < amount:
		amount = rope_needed
	var amt = player.inventory.spend_resource(player.inventory.Resources.ROPE, amount)
	rope_needed -= amt
	rope_needed = clamp(rope_needed, 0, 99999)
	
func add_meds(amount: int):
	if medecine_needed < amount:
		amount = medecine_needed
	var amt = player.inventory.spend_resource(player.inventory.Resources.MEDECINE, amount)
	medecine_needed -= amt
	medecine_needed = clamp(medecine_needed, 0, 99999)
	
func add_coats(amount: int):
	if coats_needed < amount:
		amount = coats_needed
	var amt = player.inventory.spend_resource(player.inventory.Resources.COATS, amount)
	coats_needed -= amt
	coats_needed = clamp(coats_needed, 0, 99999)
