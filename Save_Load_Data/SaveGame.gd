extends Node


func save_game()->void:
	var save_file:File = File.new()
	save_file.open("res://Save_Load_Data/game_data.json", File.WRITE)
	var save_nodes:Array = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			continue
		if !node.has_method("save"):
			continue
		var node_data:Dictionary = node.call("save")
		
		save_file.store_line(to_json(node_data))
	save_file.close()
		
	
func load_game()->void:
	var save_file:File = File.new()
	if not save_file.file_exists("res://Save_Load_Data/game_data.json"): return
	var save_nodes:Array = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
	save_file.open("res://Save_Load_Data/game_data.json", File.READ)
	while save_file.get_position() < save_file.get_len():
		var node_data:Dictionary = parse_json(save_file.get_line())
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"],node_data["pos_y"])
		
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y": continue
			new_object.set(i,node_data[i])
	save_file.close()
		
