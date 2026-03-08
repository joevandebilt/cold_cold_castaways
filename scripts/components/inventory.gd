class_name Inventory

enum Resources { WOOD, FOOD, FIBRE, MEDECINE, ROPE, COATS}

var items = {
	Resources.WOOD: 100,
	Resources.FOOD: 0, 
	Resources.FIBRE: 1000, 
	Resources.MEDECINE: 0, 
	Resources.ROPE: 0, 
	Resources.COATS: 0
}

func add_resource(resource: Resources, amount:int):
	items[resource] += amount
	
func get_resource(resource: Resources) -> int:
	return items[resource]

func spend_resource(resource: Resources, amount:int) -> int:
	if amount > items[resource]:
		amount = items[resource]
		items[resource] = 0
	else:
		items[resource] -= amount
	return amount
