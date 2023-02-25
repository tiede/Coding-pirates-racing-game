extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var omgangstid = 0
var omgang = 0
var omgangstider = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Gameover.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if omgang == 1:
		omgangstid += delta
		$HUD/Omgang1.text = 'Omgang 1: ' + str(omgangstid).pad_zeros(3).left(7)
	elif omgang == 2:
		omgangstid += delta
		$HUD/Omgang2.text = 'Omgang 2: ' + str(omgangstid).pad_zeros(3).left(7)
	elif omgang == 3:
		omgangstid += delta
		$HUD/Omgang3.text = 'Omgang 3: ' + str(omgangstid).pad_zeros(3).left(7)
	elif omgang > 3:
		# Spillet er slut - vi skal lave game over skærm
		$Gameover.visible = true
		var omgangstider_text = "Omgang 1 : " + str(omgangstider[1]).pad_zeros(3).left(7) + "\n"
		omgangstider_text += "Omgang 2 : " + str(omgangstider[2]).pad_zeros(3).left(7) + "\n"
		omgangstider_text += "Omgang 3 : " + str(omgangstider[3]).pad_zeros(3).left(7)
		$Gameover/Tider.text = omgangstider_text
		
func start_passeret():
	omgang = omgang + 1
	omgangstider.push_back(omgangstid)
	omgangstid = 0
	print('start passeret')

func hent_omgangstid(omgangstid):
	return str(omgangstid).pad_zeros(3).left(7)
