class_name WeatherController

extends GPUParticles2D

var timer : Timer
var intensity = 1


# Called when the node enters the scene tree for awhe first time.
func _ready() -> void:		
	
	timer = Timer.new()
	add_child(timer)	
	
	set_light()
	
	timer.start(get_duration())
	timer.timeout.connect(decide_weather)


func decide_weather():
	timer.stop()
	
	match randi_range(1,5):
		1,2:
			set_light()
		3,4:
			set_medium()
		5: 
			set_heavy()
	
	timer.start(get_duration())
	
func set_light():
	print("light_weather")
	speed_scale = 1
	amount = 200
	process_material = load("res://particles/snow_light.tres")
	intensity = 1
	
func set_medium():
	print("medium_weather")
	speed_scale = 5
	amount = 500
	process_material = load("res://particles/snow_light.tres")
	intensity = 1.5
	
func set_heavy():
	print("heavy_weather")
	speed_scale = 10
	amount = 500
	process_material = load("res://particles/snow_heavy.tres")
	intensity = 2

func get_duration() -> int:
	var duration  = randi_range(60, 180)
	print("Weather will last {0} seconds".format([duration]))	
	return duration

func get_extremity() -> int:
	return intensity
