extends NinePatchRect
class_name DamageOverlay

@export var duration := 0.4
@export var player: Player

var timer := 0.0
var active := false

func _ready():
	player.lose_life.connect(_on_damage_taken)
	
func _process(delta):
	if not active:
		return
	
	timer += delta
	if timer >= duration:
		active = false
		modulate.a = 0.0
	else:
		var percentage = 1.0 - (timer / duration)
		modulate.a = percentage
		
	
func _on_damage_taken():
	active = true
	timer = 0.0
	
	
