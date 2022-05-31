extends RigidBody2D


var flyVector = Vector2.ZERO



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

var maxSpeed = 65.0
var accel = 5.0
var mainAccel = 500.0
var decel = 1.0
# ---laser weapons---
export var laser_beam_duration = 1.5
export var laser_cooldown = 0.5
var can_shoot = true
var hit = null

#requires start velocity and start direction (Vector2)normalised
#model = ship skin
#func _init(velocity, direction, model):
#	#first set velocityGround
#	velocityGround = direction * velocity
#	buildModel(model)
	
enum State {
	FLYING,
	RESTING,
	DYING
}
var state = State.FLYING

# Called when the node enters the scene tree for the first time.
func _ready():
	$laser_Line2D.remove_point(1)



func _integrate_forces(st):
	var lineVelo = st.get_linear_velocity()
#	var new_anim = anim

	if state == State.DYING:
#		new_anim = "explode"
		pass
	elif state == State.FLYING:
		lineVelo = lineVelo.move_toward(flyVector * maxSpeed, accel)
	flyVector = Vector2(1,0)
	st.set_linear_velocity(lineVelo)
	decide_to_shoot()
	
func decide_to_shoot():
#	if randomize(2) is 1:
		#fire
		fire_laser()
		
		
func fire_laser():
	can_shoot = false
	hit = cast_beam()
	yield(get_tree().create_timer(laser_beam_duration), "timeout")
	$laser_Line2D.remove_point(1)
	yield(get_tree().create_timer(laser_cooldown), "timeout")
	can_shoot = true 
	
func cast_beam():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray($laser_hardpoint.global_position, $laser_hardpoint.global_position + transform.x * 1000, [self])
	if result:
		$laser_Line2D.add_point(transform.xform_inv(result.position))
	
func buildModel(model):
	$baseShip1.set_texture("/ships/baseShip1.png")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
