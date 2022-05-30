extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


var velocityGround = Vector2.ZERO
var velocityAir = 0.0
var velocityTotal = Vector2.ZERO
var velocityInerta = Vector2.ZERO
var gravity = 1.0 #todo stardise in game system
var terminalVelocity = -100
var mousePosition = Vector2.ZERO
var relativeMousePos = Vector2.ZERO
var facingDirection = 0

var testMouse = Vector2.ZERO

var maxSpeed = 650.0
var accel = 50.0
var mainAccel = 500.0
var decel = 1.0

#rotation vars TODO replace with physical value calc
var rotationSpeed = 5

# onready var animationPlayer = $AnimationPlayer
#onready var animationTree = $AnimationTree
#onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	#get mouse position from viewport (center is at center of screen)
	mousePosition = get_viewport().get_mouse_position()
	relativeMousePos = position + mousePosition
	testMouse.x = mousePosition.x - (get_viewport().size.x / 2)
	testMouse.y =  mousePosition.y - (get_viewport().size.y / 2)
	
	look_at(relativeMousePos)
#	rotateToTarget(mousePosition, delta)
	#$Sprite.look_at(mousePosition)
#	if Input.get_action_strength()

# hit the breaks - uses acceration power to stop player
	if Input.get_action_strength("ship_breaks") > 0:
		velocityGround = velocityGround.move_toward(Vector2.ZERO,accel)
	
	# use main engines - full power to the engines!
	# thrust along facing vector of ship
	if Input.get_action_strength("ship_mainEngine") > 0:
		var viewWidth = get_viewport().size
		print("Engines on!")
		print(mousePosition)
		print(testMouse)
		velocityGround = velocityGround.move_toward(testMouse.normalized() * maxSpeed, mainAccel)
		
		
	if input_vector != Vector2.ZERO:
#		animationTree.set("parameters/Idle/blend_position", input_vector)
#		animationTree.set("parameters/run/blend_position", input_vector)
#		animationState.travel("run")
		velocityGround = velocityGround.move_toward(input_vector * maxSpeed, accel)
	else:
#		animationState.travel("Idle")
		velocityGround = velocityGround.move_toward(Vector2.ZERO,decel)
	
#	if velocityAir > terminalVelocity:
#		velocityAir = velocityAir - gravity
	
	velocityInerta = velocityGround
#	if Input.get_action_strength("ui_select") > 0:
#		velocityAir = 30
	
	
	velocityTotal.x = velocityGround.x
	velocityTotal.y = velocityGround.y
	# 3d below
#	velocityTotal.y = velocityAir
#	velocityTotal.x = velocityGround.x
#	velocityTotal.z = velocityGround.y
	#move_and_collide(velocityTotal * delta)
	velocityTotal = move_and_slide(velocityTotal)
	#print(velocityTotal)

#func rotateToTarget(target, delta):
#	#var direction = (target.global_position - global_position)
#	#in radians
#	var angleTo = $Sprite.get_angle_to(target)
#	rotate(angleTo * min(delta*rotationSpeed, abs(angleTo)))
#	print(angleTo)
##	target angle
##	object angle
##	angle rot speed
##	var angleTo = $Sprite.transform.x.angle_to(target)
##	$Sprite.rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))
#

