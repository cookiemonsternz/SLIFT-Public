extends Control

@onready var slots: Array = $VBoxContainer/ArmUpgradeSlots/GridContainer.get_children()
@onready var pool: Array = $VBoxContainer/ArmUpgradePool/GridContainer.get_children()

@export var pool_item_scene: PackedScene

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

func update_pool(new_pool: Array[ArmUpgrade]):
	for upgrade in new_pool:
		if len(new_pool) > len($VBoxContainer/ArmUpgradePool/GridContainer.get_children()):
			for i in range(len(new_pool) - len($VBoxContainer/ArmUpgradePool/GridContainer.get_children())):
				var pool_item_instance = pool_item_scene.instantiate()
				
				$VBoxContainer/ArmUpgradePool/GridContainer.add_child(pool_item_instance)
				pool_item_instance.update(new_pool[i])

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("arm_upgrade_ui"):
		if is_open:
			close()
		else:
			open()
