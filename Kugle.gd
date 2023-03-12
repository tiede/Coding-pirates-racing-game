extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var speed = 500

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_Kugle_body_entered(body):
	print_debug(body)
	if body.is_in_group("Forhindring"):
		body.ramt()
	queue_free()
