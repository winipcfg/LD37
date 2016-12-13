extends RigidBody2D

var screen_size

var direction = Vector2(0, 0)
var speed = 700
var power = 200
var damage = 1
var time_autokill = 1
var dying = false
var destroyed = false

const player_class = preload("res://Scripts/player.gd")
const enemy_class = preload("res://Scripts/enemy.gd")

func _ready():
	set_fixed_process(true)
	get_node("DestroyTimer").set_wait_time(time_autokill)
	get_node("DestroyTimer").start()
	
func _fixed_process(delta):
	set_linear_velocity(direction * speed)
	pass
	
func _integrate_forces(s):	
	print(s.get_contact_count())
	for i in range(s.get_contact_count()):
		var cc = s.get_contact_collider_object(i)
		var dp = s.get_contact_local_normal(i)
		
		if (cc):
			if (not(cc extends player_class or cc extends enemy_class)):
				die(0.05)

func die(duration):
	if (duration <= 0):
		destroy()
		return
	dying = true
	var t = get_node("DestroyTimer").get_time_left()
	if (t > duration):
		get_node("DestroyTimer").set_wait_time(duration)
		get_node("DestroyTimer").start()
	pass
	
func destroy():
	dying = false
	destroyed = true
	queue_free()
	pass

func _on_Timer_timeout():
	destroy()
	pass # replace with function body
