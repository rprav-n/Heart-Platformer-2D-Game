class_name World

extends Node2D

@export var next_level: PackedScene

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var animation_player = $AnimationPlayer
@onready var start_in = %StartIn
@onready var level_time_label: Label = %LevelTimeLabel

var level_time: float = 0.0 
var start_level_msec = 0.0

func _ready():
	Events.level_completed.connect(show_level_completed)
	get_tree().paused = true
	start_in.visible = true
	await LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_in.visible = false
	start_level_msec = Time.get_ticks_msec()

func _process(_delta: float):
	level_time = Time.get_ticks_msec() - start_level_msec
	level_time_label.text = str(level_time / 1000.0)

func go_to_next_level():
	if not next_level is PackedScene: return
	
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	#LevelTransition.fade_from_black()

func show_level_completed():
	level_completed.show()
	level_completed.retry_button.grab_focus()
	get_tree().paused = true


func _on_level_completed_next_level():
	go_to_next_level()


func _on_level_completed_retry():
	get_tree().reload_current_scene()
