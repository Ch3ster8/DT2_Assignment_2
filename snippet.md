**EVIDENCE, NOT WORD COUNT**
```py
var dir = DirAccess.open("user://")
	if !dir.dir_exists("user://GameSave"):
		dir.make_dir("GameSave")
		DirAccess.make_dir_absolute("user://GameSave")
```

This snippet of code is what I used to allow the file path to start with “user://”. This code opens the file path “user://” but with Godot, the location of this is actually “User\AppData\Roaming\Godot\app_userdata\Assignment_3” which in my case, my project was named “Assignment_3”, then it checks if there's a folder named “GameSave” and if there isn't then it creates it and then tells the filesystem that it's permanently there which allows me to access the files later on.
