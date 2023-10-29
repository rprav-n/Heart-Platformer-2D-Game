class_name PlayerMovementData

extends Resource

@export var speed: int = 80
@export var jump_speed: int = -300
@export var acceleration: int = 800
@export var friction: int = 1000
@export var air_resistance: int = 200

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
