```py
var dir = DirAccess.open("user://")
	if !dir.dir_exists("user://GameSave"):
		dir.make_dir("GameSave")
		DirAccess.make_dir_absolute("user://GameSave")
```

This snippet of code is what I used to allow the file path to start with “user://”. This code opens the file path “user://” but with my project in Godot, the location of this is actually “User\AppData\Roaming\Godot\app_userdata\Assignment_3”.
I made this code to read files saved directly on the hard drive as an exported Godot project will not read from "res://" but instead from “user://” which will result in the wrong file if saved to the Godot project rather than the hard drive.
