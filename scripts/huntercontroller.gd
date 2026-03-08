class_name HunterController

extends NpcController

var fire : FireController

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	fire = get_node("/root/Game Scene/Camp/Fire")	
		
	craft_time = 300
		
	collect_gather.connect(gather_wood_reward)
	collect_craft.connect(gather_coat_reward)
	start_craft.connect(pay_crafting)
	_base_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if !awake and fire.fuel_available > 0:
		awake = true
		npc_dialogue.text = "I'm hunter, I can gather food or I can make coats to help us survive the cold"
		
	can_craft = has_craft_requirement()
	
	_base_process(delta)
	
func gather_wood_reward():
	print("Finished Gathering Wood")
	player.inventory.add_resource(player.inventory.Resources.WOOD, 200)
	
func gather_coat_reward():
	print("Finished Crafting Coat")
	player.inventory.add_resource(player.inventory.Resources.COATS, 1)
	
func has_craft_requirement() -> bool:	
	return player.inventory.get_resource(player.inventory.Resources.FIBRE) >= 100
	
func pay_crafting():
	player.inventory.spend_resource(player.inventory.Resources.FIBRE, 100)
