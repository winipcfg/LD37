extends RigidBody2D

var screen_size

var health = 1
var speed = 300
var shooting = false
var killed = false

var shoot_time = 0
var shoot_interval = 0.25

const bullet = preload("res://Scenes/bullet.tscn")

func _ready():
	screen_size = get_viewport().get_rect().size
	set_fixed_process(true)
	
func _fixed_process(delta):
	if (killed):
		return
		
	var motion = Vector2()
	if Input.is_action_pressed("move_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)
	
	var pos = get_pos()
	
	pos += motion.normalized() * delta * speed
#	if (pos.x < 0):
#		pos.x = 0
#	if (pos.x > screen_size.x):
#		pos.x = screen_size.x
#	if (pos.y < 0):
#		pos.y = 0
#	if (pos.y > screen_size.y):
#		pos.y = screen_size.y
	
	set_pos(pos)
	

	var mpos = get_node("Camera2D").get_global_mouse_pos()
	look_at(mpos)
			
	var shoot = Input.is_action_pressed("shoot")
	if (shoot and not shooting):
		shoot_time = 0
		shooting = true
	elif (shoot and shooting):
		shoot_time += delta
		var fire = false;
		while (shoot_time > shoot_interval):
			fire = true;
			var obj = bullet.instance()
			var pos = get_node("gun").get_global_pos()
			obj.set_pos(pos)
			
			get_parent().add_child(obj)
			
			obj.look_at(mpos)
			
			var direction = mpos - pos
			direction = direction.normalized()
			obj.direction = direction
			
			shoot_time -= shoot_interval
		
		if (fire):
			get_node("audio").play("Laser_Shoot")
			
	elif (shooting and not shoot):
		shoot_time = 0
		shooting = false
		
	#get_node("hud/score").set_text("SCORE: " + str(get_parent().score))

func take_damage(value):
	health -= value;
	if (health <= 0):
		die();
		
func die():
	get_parent().gameover()
	pass