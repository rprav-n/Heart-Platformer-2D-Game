extends CenterContainer


@onready var start_menu_button = $VBoxContainer/StartMenuButton


func _ready():
	LevelTransition.fade_from_black()
	start_menu_button.grab_focus()
	

func _on_start_menu_button_pressed():
	get_tree().change_scene_to_file("res://ui/menu/start_menu.tscn")
