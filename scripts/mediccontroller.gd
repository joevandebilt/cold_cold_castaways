class_name MedicController

extends NpcController

var give_coat_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
			
	craft_time = 60
		
	collect_craft.connect(craft_meds_reward)
	start_craft.connect(pay_crafting)
	_base_ready()
	
	give_coat_button = npc_menu.get_node("Margins/VContainer/GiveCoatButton")
	give_coat_button.pressed.connect(_revive_medic)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	can_craft = has_craft_requirement()	
	_base_process(delta)

func _revive_medic():
	if player.inventory.get_resource(player.inventory.Resources.COATS) >= 1:
		player.inventory.spend_resource(player.inventory.Resources.COATS, 1)
		awake = true
		npc_dialogue.text = "I'm a doctor, I can make medecine to keep us healthy"
		give_coat_button.hide()
		
func craft_meds_reward():
	print("Finished Gathering Wood")
	player.inventory.add_resource(player.inventory.Resources.MEDECINE, 10)
	
func has_craft_requirement() -> bool:	
	return player.inventory.get_resource(player.inventory.Resources.FIBRE) >= 50 and \
			player.inventory.get_resource(player.inventory.Resources.FOOD) >= 100
	
func pay_crafting():
	player.inventory.spend_resource(player.inventory.Resources.FIBRE, 50)
	player.inventory.spend_resource(player.inventory.Resources.FOOD, 100)
