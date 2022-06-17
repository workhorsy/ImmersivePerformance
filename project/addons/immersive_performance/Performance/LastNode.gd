# Copyright (c) 2022 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
# This file is licensed under the MIT License
# https://github.com/workhorsy/ImmersivePerformance

extends Node

func _physics_process(_delta : float) -> void:
	#print("last physics frame:%s ticks:%s" % [self.get_tree().get_frame(), OS.get_ticks_msec()])
	ImmersivePerformance._on_last_node_physics_process()

func _process(_delta : float) -> void:
	#print("last process frame:%s ticks:%s" % [self.get_tree().get_frame(), OS.get_ticks_msec()])
	ImmersivePerformance._on_last_node_process()
