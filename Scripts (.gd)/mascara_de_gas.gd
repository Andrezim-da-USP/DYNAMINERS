extends Coletavel


func _ready():
	pass


func _on_Coletavel_body_entered(body):
	if body.is_in_group("Player"):
		body.emit_signal("coletou_mascara_de_gas")
		self.queue_free()
	pass # Replace with function body.
