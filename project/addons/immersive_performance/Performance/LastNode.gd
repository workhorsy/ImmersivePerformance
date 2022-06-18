# Copyright (c) 2022 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
# This file is licensed under the MIT License
# https://github.com/workhorsy/ImmersivePerformance

extends Node

var _prev_frame := -1

func _physics_process(_delta : float) -> void:
	if ImmersivePerformance.is_logging: print("last physics frame:%s ticks:%s" % [self.get_tree().get_frame(), OS.get_ticks_msec()])
	ImmersivePerformance._on_last_node_physics_process()

func _process(_delta : float) -> void:
	var frame := self.get_tree().get_frame()
	if frame == _prev_frame: return
	_prev_frame = frame
	if ImmersivePerformance.is_logging: print("last process frame:%s ticks:%s" % [frame, OS.get_ticks_msec()])
	ImmersivePerformance._on_last_node_process()
