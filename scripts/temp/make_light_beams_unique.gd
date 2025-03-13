@tool
extends Node2D

@export var shade: Shader

@export var mybutton: bool:
	set(value):
		on_do_stuff()

func on_do_stuff():
	print(get_children())
	var arr = []
	for child: ColorRect in get_children():
		print(child)
		child.material.set("shader", shade)
		child.material.set("shader_parameter/color", Vector4(1.0, 0.95, 0.825, 1.0))
		child.material.set("shader_parameter/falloff", 2.0)
		child.material.set("shader_parameter/ray1_intensity", 0.7)
		child.material.set("shader_parameter/ray2_intensity", 0.7)
		child.material = child.material.duplicate(true)
		child.material.set_shader_parameter("shader_parameter/seed", randf_range(-50, 50))
		
		print(child.material.get_shader_parameter("shader_parameter/seed"))
	for child in get_children():
		arr.append(child.material.get_shader_parameter("shader_parameter/seed"))
	# print amount of each seed
	var seed_counts = {}
	for seed_value in arr:
		if seed_value in seed_counts:
			seed_counts[seed_value] += 1
		else:
			seed_counts[seed_value] = 1
	print("Seed counts: ", seed_counts)
