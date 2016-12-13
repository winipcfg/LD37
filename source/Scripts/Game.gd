extends Node2D

var highscore = 0;
var score = 0

const HEALTH_MIN = 2
const HEALTH_MAX = 20
const SPEED_MIN = 20
const SPEED_MAX = 40

const enemy = preload("res://Scenes/enemy.tscn")

func _ready():
	var f = File.new()
	if (f.open("user://highscore.sav", File.READ) == OK):
		highscore = f.get_var()
		if (highscore == null):
			highscore = 0
			
#	get_node("bgmusic").play()
	var t = get_node("bgmusic").get_stream()
	get_node("bgmusic").play()
	
	get_node("SpawnTimer").start()

func add_score(value):
	score += value
	
func gameover():
	if (score > highscore):
		var f = File.new()
		f.open("user://highscore.sav", File.WRITE)
		f.store_var(score)
		
	get_tree().change_scene("res://Scenes/GameOver.tscn")

func _on_SpawnTimer_timeout():
	var p = get_node("SpawnRegion").get_pos()	
	var p2 = get_node("SpawnRegion1").get_pos()
	var d = (SPEED_MAX - SPEED_MIN) + 1
	var dhp = (HEALTH_MAX - HEALTH_MIN) + 1
	
	var speed = SPEED_MIN + randi()%d
	var hp = HEALTH_MIN + randi()%dhp
	spawn_enemy(p, hp, speed)
	
	speed = SPEED_MIN + randi()%d	
	hp = HEALTH_MIN + randi()%dhp
	spawn_enemy(p2, hp, speed)

func spawn_enemy(pos, hp, speed):
	var obj = enemy.instance()
	obj.set_pos(pos)
	obj.health = hp
	obj.speed = speed
	get_node("enemies").add_child(obj)