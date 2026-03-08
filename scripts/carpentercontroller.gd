class_name CarpenterController

extends NpcController

var give_meds_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
		
	craft_time = 60
	gather_time = 30
		
	collect_gather.connect(gather_wood_reward)
	collect_craft.connect(craft_rope_reward)
	start_craft.connect(pay_crafting)
	_base_ready()
	
	give_meds_button = npc_menu.get_node("Margins/VContainer/GiveMedsButton")
	give_meds_button.pressed.connect(_revive_carpenter)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	can_craft = has_craft_requirement()	
	_base_process(delta)
	
func gather_wood_reward():
	print("Finished Gathering Food")
	player.inventory.add_resource(player.inventory.Resources.WOOD, 200)
	
func craft_rope_reward():
	print("Finished Crafting Rope")
	player.inventory.add_resource(player.inventory.Resources.ROPE, 15)
	
func has_craft_requirement() -> bool:	
	return player.inventory.get_resource(player.inventory.Resources.FIBRE) >= 30
	
func pay_crafting():
	player.inventory.spend_resource(player.inventory.Resources.FIBRE, 30)
	
func _revive_carpenter():
	if player.inventory.get_resource(player.inventory.Resources.MEDECINE) >= 10:
		player.inventory.spend_resource(player.inventory.Resources.MEDECINE, 1)
		awake = true
		npc_dialogue.text = "I'm a carpenter, I can gather wood or I can make ropes to help us repair the boat, let me teach you how to fell trees too!\r\n\r\n*You have learned how to chop trees*"
		give_meds_button.hide()
