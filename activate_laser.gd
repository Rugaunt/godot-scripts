extends Node2D


# ---laser weapons---
export var laser_beam_duration = 1.5
export var laser_cooldown = 0.5
var can_shoot = true
var hit = null
var laser_range = 1000
var laserEndpoint = null
var beamtarget = preload("res://targetPainter1.tscn") #debug, will target end of raycast

#test
onready var ray:=$RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$laser_beam.remove_point(1)
	
	
	
func fire_laser():
	can_shoot = false
	hit = cast_beam()
	yield(get_tree().create_timer(laser_beam_duration), "timeout")
	hit = null
	$laser_beam.remove_point(1)
	yield(get_tree().create_timer(laser_cooldown), "timeout")
	can_shoot = true 
	
func cast_beam():
	var result2 = null
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(
		global_position, 
		global_position + transform.x * laser_range, 
		[self])
	print("laser position")
	print(global_position)
	print(global_position + transform.x *laser_range)
	

	###test use internal raycast###
#	
	if $RayCast2D.is_colliding():
		print("hit detected: laser raycast")
		result2 = ray.get_collision_point() 
		print(result2)
		laserEndpoint = global_position - result2
	else:
		print("no hit detected") #debug
#		
#	###END test###
#	$laser_Line2D.add_point(Vector2($laser_hardpoint.position.x + laser_range, $laser_hardpoint.position.y)) #Debug this works: problem is elsewhere
	if result2:
		print("rayfound!")
		print(result.values())
		if !hit:
			$laser_beam.add_point(to_local(result2))
			#####DEBUG###
			var ins = beamtarget.instance()
			ins.position = to_local(result2)
			add_child(ins)
			print("position of hit")
			print(position)
			print("result")
			print(result2)
			print("basepoint")
			print($laser_beam.get_point_position(0))
			print("targetpoint")
			print($laser_beam.get_point_position(1))
			#####DEBUG END###
#		else:
			$laser_beam.set_point_position(1, to_local(result2))
			#####DEBUG###
			print("position")
			print(position)
			print("result")
			print(result2)
			print("basepoint")
			print($laser_beam.get_point_position(0))
			print("targetpoint")
			print($laser_beam.get_point_position(1))
			#####DEBUG END###
	else:
		$laser_beam.add_point(Vector2(position.x + laser_range, position.y)) 
		
	return result2

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
