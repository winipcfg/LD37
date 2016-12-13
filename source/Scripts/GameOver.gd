extends Control

var highscore = 0;

func _ready():
	var f = File.new()
	if (f.open("user://highscore.sav", File.READ) == OK):
		highscore = f.get_var()
		get_node("highscore").set_text(str(highscore))
		
	get_node("audio").play("error")

func _on_play_pressed():
	get_tree().change_scene("res://Scenes/Game.scn")
