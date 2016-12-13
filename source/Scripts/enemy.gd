extends RigidBody2D

var STATE_NORMAL = 0
var STATE_HIT = 1
var STATE_DEATH = 2

var health = 1
var speed = 20

#const HEALTH_MIN = 1
#const HEALTH_MAX = 5
#const SPEED_MIN = 20
#const SPEED_MAX = 40

var state = null
var killed = false

var player = null
var root = null

const player_class = preload("res://Scripts/player.gd")
const bullet_class = preload("res://Scripts/bullet.gd")

var variance = Vector2(0, 0)

func _ready():
	state = STATE_NORMAL
	root = get_parent().get_parent()
	player = root.get_node("player")
	set_fixed_process(true)
	get_node("VarTimer").start()
	
func _fixed_process(delta):
	if (killed):
		return		
	
	var mpos = player.get_pos()
	look_at(mpos)
	
	var dir = (mpos - get_global_pos()).normalized()
	
	dir = (dir + variance * 0.7)
	dir = dir.normalized()
	
	apply_impulse(Vector2(0, 0), dir*speed)
	
func _integrate_forces(s):	
	print(s.get_contact_count())
	for i in range(s.get_contact_count()):
		var cc = s.get_contact_collider_object(i)
		var dp = s.get_contact_local_normal(i)
		
		if (cc):
			if (cc extends bullet_class and not cc.dying and not cc.destroyed):
				var p = cc.get_linear_velocity().normalized()
				apply_impulse(Vector2(0, 0), p * cc.power)
				health -= cc.damage
				if (health <= 0):
					die()
				cc.die(0)
			elif (cc extends player_class):
				cc.take_damage(1)
				pass
				
func die():
	get_parent().get_parent().add_score(1)
	queue_free()
	pass

func _on_VarTimer_timeout():
	variance = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	pass # replace with function body
