extends KinematicBody

var velocityGround = Vector2.ZERO
var velocityAir = 0.0
var velocityTotal = Vector3.ZERO
var velocityInerta = Vector2.ZERO
var gravity = 7.0 #todo stardise in game system
var terminalVelocity = -100

var maxSpeed = 65.0
var accel = 5.0
var decel = 5.0

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/run/blend_position", input_vector)
		animationState.travel("run")
		velocityGround = velocityGround.move_toward(input_vector * maxSpeed, accel)
	else:
		animationState.travel("Idle")
		velocityGround = velocityGround.move_toward(Vector2.ZERO,decel)
	
	if velocityAir > terminalVelocity:
		velocityAir = velocityAir - gravity
	
	velocityInerta = velocityGround
	if Input.get_action_strength("ui_select") > 0:
		velocityAir = 30
	
	velocityTotal.y = velocityAir
	velocityTotal.x = velocityGround.x
	velocityTotal.z = velocityGround.y
	#move_and_collide(velocityTotal * delta)
	velocityTotal = move_and_slide(velocityTotal)
	#print(velocityTotal)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
