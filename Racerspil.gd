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
	omgangstid += delta
	if omgang == 1:
		$HUD/Omgang1.text = 'Omgang 1: ' + hent_omgangstid(omgangstid)
	elif omgang == 2:
		$HUD/Omgang2.text = 'Omgang 2: ' + hent_omgangstid(omgangstid)
	elif omgang == 3:
		$HUD/Omgang3.text = 'Omgang 3: ' + hent_omgangstid(omgangstid)
	elif omgang > 3:
		# Spillet er slut - vi skal lave game over skærm
		$Gameover.visible = true
		var omgangstider_text = "Omgang 1 : " + hent_omgangstid(omgangstider[1]) + "\n"
		omgangstider_text += "Omgang 2 : " + hent_omgangstid(omgangstider[2]) + "\n"
		omgangstider_text += "Omgang 3 : " + hent_omgangstid(omgangstider[3])
		
		var total_tid = omgangstider[1] + omgangstider[2] + omgangstider[3]
		
		$Gameover/Tider.text = omgangstider_text + "\n" + "Total tid : " + hent_omgangstid(total_tid)
		
func start_passeret():
	omgang = omgang + 1
	omgangstider.push_back(omgangstid)
	omgangstid = 0
	print('start passeret')

func hent_omgangstid(omgangstid):
	return str(omgangstid).pad_zeros(3).left(7)


func _on_Start_pressed():
	get_tree().reload_current_scene()
