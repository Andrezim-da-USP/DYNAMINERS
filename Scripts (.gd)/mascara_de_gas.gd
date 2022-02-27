extends Coletavel

onready var tween = get_node("Tween")
var initial_position = Vector2(0,0)
var final_position = Vector2(0,-8)

func _ready():
	rotate_animation()

func rotate_animation():
	tween.interpolate_property(
		self,
		"global_position",
		global_position,
		global_position + final_position,
		1.5,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(
		self,
		"global_position",
		global_position,
		global_position - final_position,
		1.5,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	rotate_animation()

func _on_Coletavel_body_entered(body:Player):
	if not body:
		return
	body.emit_signal("coletou_mascara_de_gas")
	self.queue_free()
	pass # Replace with function body.
