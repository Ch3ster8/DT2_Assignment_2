extends Node

var path = "user://GameSave/save"
var resourcePath = "user://GameSave/SavedScene"
var settingsPath = "user://GameSave/SavedSettings"
var currentSave = 1
#Makes sure the file path exists, if it isnt then it creates that file path,
#Loads any ConfigFile data if it exists
func _ready():
	var dir = DirAccess.open("user://")
	if !dir.dir_exists("user://GameSave"):
		dir.make_dir("GameSave")
		DirAccess.make_dir_absolute("user://GameSave")
	if FileAccess.file_exists(path + str(currentSave) + ".cfg"):
		load_save_config(currentSave)
	else:
		GController.Load()
	load_settings()
	
#Saves only the settings by overriding the old ConfigFile for settings
#Loops through all the nodes in the group "saveSettings" and saves all the variables given in get_data() under that nodes filepath
func save_settings():
	var config = ConfigFile.new()
	var save_nodes = get_tree().get_nodes_in_group("saveSettings")
	for node in save_nodes:
		if node:
			var data = node.get_settings()
			for key in data:
				config.set_value(node.get_path(), key, data[key])
	config.save(settingsPath + ".cfg")
	
#Loops through the configFile and sets all the variables of all the saved nodes
func load_settings():
	var config = ConfigFile.new()
	if config.load(settingsPath + ".cfg") == OK:
		for section in config.get_sections():
			var node = get_node_or_null(section)
			if node:
				for key in config.get_section_keys(section):
					var data = config.get_value(section, key)
					node.set(key, data)
					if node.has_method("Load"):
						node.Load()
	else:
		print("File does not exist at " + settingsPath + ".cfg")
#Loops through all the nodes in the group "save" and saves all the variables given in get_data() under that nodes filepath
func save_config(id : int):
	var config = ConfigFile.new()
	var save_nodes = get_tree().get_nodes_in_group("save")
	for node in save_nodes:
		if node:
			var data = node.get_data()
			for key in data:
				config.set_value(node.get_path(), key, data[key])
	config.save(path + str(id) + ".cfg")
	
#Loops through the configFile and sets all the variables of all the saved nodes
func load_save_config(id : int):
	var config = ConfigFile.new()
	if config.load(path + str(id) + ".cfg") == OK:
		for section in config.get_sections():
			var node = get_node_or_null(section)
			if node:
				for key in config.get_section_keys(section):
					var data = config.get_value(section, key)
					node.set(key, data)
					if node.has_method("Load"):
						node.Load()
	else:
		print("File does not exist at " + path + str(id) + ".cfg")
#Checks if the config file exists		
func check_config(id : int):
	var config = ConfigFile.new()
	var err = config.load(path + str(id) + ".cfg")
	if err != OK:
		return false
	else:
		return true
#Deletes the ConfigFile
func delete_config(id : int):
	if check_config(id):
		var dir = DirAccess.open("user://")
		dir.remove(path + str(id) + ".cfg")
#Deletes the resourceSaver file
func delete_resourceSaver(id : int):
	var dir = DirAccess.open("user://")
	if dir.file_exists(resourcePath + str(id) + ".tscn"):
		dir.remove(resourcePath + str(id) + ".tscn")
		
#Saves the current scene using the inbuilt ResourceSaver
func save_resourceSaver(id : int):
	var packed_scene = PackedScene.new()
	var root = get_tree().current_scene
	#Children have to be owned to get packed into a scene
	set_children_as_owned(root)
	packed_scene.pack(root)
	ResourceSaver.save(packed_scene, resourcePath + str(id) + ".tscn")
	
#Recursively looops through all nodes except for tilemap nodes to ensure no duplicates of scenes placed using tilemap,
#and sets their owners as the node decided
func set_children_as_owned(node: Node, owner_node: Node = node):
	if !node is TileMap:
		for child in node.get_children():
			child.owner = owner_node
			set_children_as_owned(child, owner_node)

#Load the saved scene using the resourceSaver, also make sure the file exists before loading
func load_resourceSaver(id : int):
	var dir = DirAccess.open("user://")
	if dir.file_exists(resourcePath + str(id) + ".tscn"):
		GController.change_scene_to_file(resourcePath + str(id) + ".tscn")
		GController.EnableUI()
	else:
		print("File does not exist at " + resourcePath + str(id) + ".tscn")
