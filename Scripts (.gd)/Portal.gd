extends Area2D

export(NodePath) var previousLevel 
export(NodePath) var nextLevel 

onready var former_camera:Camera2D = get_node(previousLevel) as Camera2D
onready var next_camera:Camera2D = get_node(nextLevel) as Camera2D

func _on_Portal_body_entered(body:Player)->void:
	if not body: return
	if not previousLevel or not nextLevel:
		return
	else:
		if former_camera.is_current():
			former_camera._set_current(false)
			next_camera._set_current(true)
			var aux:Camera2D = next_camera
			next_camera = former_camera
			former_camera = aux
		else: 
			return
