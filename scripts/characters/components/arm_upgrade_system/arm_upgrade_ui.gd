extends Control

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready() -> void:
	close()

func update_slots(installed_upgrades):
	for key in installed_upgrades[0].keys():
		if installed_upgrades[0].size() > 6:
			printerr("Too many upgrades, need a better cap system but for now just have an error")
			#EngineDebugger.debug(false, true)
			return
		else:
			slots[key].update(installed_upgrades[0][key])
	for i in range(6):
		if not installed_upgrades[0].has(i):
			slots[i].update(null)
	
	for key in installed_upgrades[1].keys():
		if installed_upgrades[1].size() > 6:
			printerr("Too many upgrades, need a better cap system but for now just have an error")
			#EngineDebugger.debug(false, true)
			return
		else:
			#print(installed_upgrades[1][key])
			slots[key + 6].update(installed_upgrades[1][key])
	for i in range(6):
		if not installed_upgrades[1].has(i):
			slots[i + 6].update(null)

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("arm_upgrade_ui"):
		if is_open:
			close()
		else:
			open()
