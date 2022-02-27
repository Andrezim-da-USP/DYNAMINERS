extends Coletavel


func _ready():
	pass


func _on_Bomba_coletavel__body_entered(body:Player):
	if not body:
		return
	body.emit_signal("alterou_qtd_bomba",1)
	self.queue_free()
	pass # Replace with function body.
