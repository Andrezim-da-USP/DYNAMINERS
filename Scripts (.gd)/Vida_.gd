extends Coletavel

export(int) var valor = 10

func _ready():
	pass

func _on_Vida__body_entered(body:Player):
	if not body:
		return
	body.emit_signal("vida_mudou", valor)
	self.queue_free()
	pass # Replace with function body.
