extends Area2D

export(String,FILE,"*.tscn") var nextLevel = ""

func _on_Portal_body_entered(body:Player)->void:
	if not body: return
	if nextLevel == "":
		return
	else:
		get_tree().change_scene(nextLevel)
