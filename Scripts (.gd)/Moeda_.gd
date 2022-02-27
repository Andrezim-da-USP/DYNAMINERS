extends Coletavel


func _ready():
	pass

func _on_Moeda__body_entered(body:Player)->void:
	if not body:
		return
	body.emit_signal("coletou_moeda")
	self.queue_free()
	pass # Replace with function body.
