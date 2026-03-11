class_name WeatherController

extends GPUParticles2D

var timer : Timer
var intensity = 1

var darkness : ColorRect

var light_snow_material : ParticleProcessMaterial
var heavy_snow_material : ParticleProcessMaterial


# Called when the node enters the scene tree for awhe first time.
func _ready() -> void:		
	
	light_snow_material = preload("res://particles/snow_light.tres")
	heavy_snow_material = preload("res://particles/snow_heavy.tres")
	
	darkness = get_node("WeatherDarkness")
	
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
	set_weather(light_snow_material, 1, 200, 0, 1)
	
func set_medium():
	print("medium_weather")
	set_weather(light_snow_material, 5, 500, 25, 1.5)
	
func set_heavy():
	print("heavy_weather")
	set_weather(heavy_snow_material, 10, 500, 50, 2)

func set_weather(weathermaterial: ParticleProcessMaterial, speedscale: int, amountscale:int, darknesslevel: float, intensity_level: float):
	var tween = create_tween()
	tween.tween_property(darkness, "color:a", (darknesslevel/255), 0.1)
	await tween.finished		
	process_material = weathermaterial
	speed_scale = speedscale
	amount = amountscale
	intensity = intensity_level
	

func get_duration() -> int:
	var duration  = randi_range(60, 180)
	#duration = 30
	print("Weather will last {0} seconds".format([duration]))	
	return duration

func get_extremity() -> int:
	return intensity
