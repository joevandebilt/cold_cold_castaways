extends CanvasLayer

#Child Nodes
var eat_button : Button
var campfire_button : Button

#Stats
var exposure_label : Label
var health_label : Label
var hunger_label : Label

#Inventory
var food_label : Label
var wood_label : Label
var fibre_label : Label
var rope_label: Label
var med_label: Label
var coat_label: Label

#Sibling nodes
var player : PlayerController
var map : MapController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game Scene/Camp/Player")
	map = get_node("/root/Game Scene/TileMap")
	
	eat_button = get_node("InventoryContainer/InventoryPanel/InventoryMargin/InventoryVbox/FoodCount/EatFoodButton")
	eat_button.pressed.connect(player.eat_food)
	
	campfire_button = get_node("InventoryContainer/InventoryPanel/InventoryMargin/InventoryVbox/WoodCount/MakeCampfireButton")
	campfire_button.pressed.connect(_make_campfire)
	
	exposure_label = get_node("StatsContainer/StatsPanel/StatsMargin/StatsVbox/ExposureStat/ExposureLabel")
	health_label = get_node("StatsContainer/StatsPanel/StatsMargin/StatsVbox/HealthStat/HealthLabel")
	hunger_label = get_node("StatsContainer/StatsPanel/StatsMargin/StatsVbox/HungerStat/HungerLabel")

	food_label = get_node("InventoryContainer/InventoryPanel/InventoryMargin/InventoryVbox/FoodCount/FoodLabel")
	wood_label = get_node("InventoryContainer/InventoryPanel/InventoryMargin/InventoryVbox/WoodCount/WoodLabel")
	fibre_label = get_node("InventoryContainer/InventoryPanel/InventoryMargin/InventoryVbox/FibreCount/FibreLabel")
	rope_label = get_node("InventoryContainer/InventoryPanel/InventoryMargin/InventoryVbox/RopeCount/RopeLabel")
	med_label = get_node("InventoryContainer/InventoryPanel/InventoryMargin/InventoryVbox/MedCount/MedsLabel")
	coat_label = get_node("InventoryContainer/InventoryPanel/InventoryMargin/InventoryVbox/CoatsCount/CoatsLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	exposure_label.text = "Exposure: {0}%".format([roundi(player.get_exposure())])
	health_label.text = "Health: {0}%".format([roundi(player.get_health())])	
	hunger_label.text = "Hunger: {0}%".format([roundi(player.get_hunger())])
	
	var resources = player.inventory.Resources
	food_label.text = "Food: {0}".format([player.inventory.get_resource(resources.FOOD)])
	wood_label.text = "Wood: {0}".format([player.inventory.get_resource(resources.WOOD)])
	fibre_label.text = "Fibre: {0}".format([player.inventory.get_resource(resources.FIBRE)])
	rope_label.text = "Rope: {0}".format([player.inventory.get_resource(resources.ROPE)])
	med_label.text = "Meds: {0}".format([player.inventory.get_resource(resources.MEDECINE)])
	coat_label.text = "Coats: {0}".format([player.inventory.get_resource(resources.COATS)])
	
func _make_campfire():
	if player.inventory.get_resource(player.inventory.Resources.WOOD) >= 100:
		player.inventory.spend_resource(player.inventory.Resources.WOOD, 100)
		map.add_campfire(player.global_position)
