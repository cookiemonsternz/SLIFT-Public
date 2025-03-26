@tool
extends Node2D

@export var do_thing: bool: 
	set(value):
		do_func()


func do_func():
	for child in get_children():
		if child is GPUParticles2D:
			child.process_material.set_param_min(ParticleProcessMaterial.PARAM_HUE_VARIATION, 0.0)
			child.process_material.set_param_max(ParticleProcessMaterial.PARAM_HUE_VARIATION, 0.2)
