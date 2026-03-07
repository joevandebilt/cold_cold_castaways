extends Area2D

var fern_sprite : AnimatedSprite2D
var timer : Timer

var player : PlayerController

var fern_knocked : bool = false
var fern_harvested : bool = false
var fern_hits : int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fern_sprite = get_node("FernSprite")
	
	player = get_node("/root/Game Scene/Camp/Player")
	
	area_entered.connect(_collide)
	body_entered.connect(_collide)
	
	fern_sprite.play()
	
	timer = Timer.new()
	add_child(timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _collide(body: Node2D):
	#print("fern collide")
	if body is PlayerController:
		_knock()

func _knock():
	if fern_hits > 0:
		if !fern_knocked:
			print("player knocked the fern")
			fern_sprite.animation = "knock"
			fern_sprite.frame = 0
			fern_sprite.play()
			fern_knocked = true
		elif fern_harvested:
			print("player knocked the tree")
			fern_sprite.animation = "harvested_wobble"
			fern_sprite.frame = 0
			fern_sprite.play()
		elif !fern_harvested:
			print("player knocked the tree")
			fern_sprite.animation = "unharvested_wobble"
			fern_sprite.frame = 0
			fern_sprite.play()
			
func interact():
	_knock()
	if fern_sprite.animation_finished and fern_hits > 0:
		fern_hits -= 1
		print("Fern hits {0}".format([fern_hits]))
		
		if fern_hits == 0:			
			player.inventory.add_resource(player.inventory.Resources.FIBRE, 5)
			fern_sprite.animation = "timber"
			fern_sprite.frame = 0
			fern_sprite.play()
			
			timer.start(60)
			timer.timeout.connect(respawn)
		else:
			fern_harvested = true
			fern_sprite.animation = "harvested_wobble"
			fern_sprite.frame = 0
			fern_sprite.play()
			player.inventory.add_resource(player.inventory.Resources.FOOD, 3)
			
func respawn():
	print("Respawning Fern")
	fern_sprite.animation = "default"
	fern_sprite.frame = 0
	fern_sprite.play()
	
	fern_hits = 2
	fern_knocked = false
	fern_harvested = false
	
	
