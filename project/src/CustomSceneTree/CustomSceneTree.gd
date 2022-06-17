# Copyright (c) 2022 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
# This file is licensed under the MIT License
# https://github.com/workhorsy/ImmersivePerformance

extends SceneTree
class_name CustomSceneTree

var _immersive_performance = null


func _initialize() -> void:
	_immersive_performance = self.current_scene.get_node_or_null("/root/ImmersivePerformance")
	_immersive_performance.setup(self)

	print("Custom Scene Tree Initialized")

func _finalize() -> void:
	print("Custom Scene Tree Finalized")

func _idle(delta : float) -> bool:
	#print("tree process frame:%s ticks:%s" % [self.get_frame(), OS.get_ticks_msec()])
	return _immersive_performance._idle(delta)

func _iteration(delta : float) -> bool:
	#print("tree physics frame:%s ticks:%s" % [self.get_frame(), OS.get_ticks_msec()])
	return _immersive_performance._iteration(delta)

func _input_event(_event) -> void:
	pass

