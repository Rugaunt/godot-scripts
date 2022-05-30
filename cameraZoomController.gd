extends Camera2D


var zoom_min = Vector2(.2, .2)
var zoom_max = Vector2(20, 20)
var zoom_speed = Vector2(.2, .2)

var desired_zoom = zoom

func _process(delta):
	zoom = lerp(zoom, desired_zoom, .2)

func _input(event):
	if (event is InputEventMouseButton):
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if desired_zoom > zoom_min:
					desired_zoom -= zoom_speed
					if desired_zoom < zoom_min:
						desired_zoom = zoom_min
			if event.button_index == BUTTON_WHEEL_DOWN:
				if desired_zoom < zoom_max:
					desired_zoom += zoom_speed
					if desired_zoom > zoom_max:
						desired_zoom = zoom_max
			print(zoom)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
