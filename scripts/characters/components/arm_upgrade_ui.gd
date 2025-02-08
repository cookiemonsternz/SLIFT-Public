extends Control

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready() -> void:
	close()

func update_slots(installed_upgrades):
	#print(installed_upgrades[0][0].name)
	for i in range(6):
		if len(installed_upgrades[0]) > 6:
			printerr("Too many upgrades, need a better cap system but for now just have an error")
			#EngineDebugger.debug(false, true)
			return
		if len(installed_upgrades[0]) - 1 < i:
			slots[i].update(null)
		else:
			slots[i].update(installed_upgrades[0][i])
		
	for i in range(6):
		if len(installed_upgrades[1]) > 6:
			printerr("Too many upgrades, need a better cap system but for now just have an error")
			#EngineDebugger.debug(false, true)
			return
		if len(installed_upgrades[1]) - 1 < i:
			slots[i + 6].update(null)
		else:
			slots[i + 6].update(installed_upgrades[1][i])

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
