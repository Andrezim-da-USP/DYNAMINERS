extends Area2D



func _on_Save_Spot_body_entered(body:Player):
	if not body: return
	SaveGame.save_game()
	pass # Replace with function body.
