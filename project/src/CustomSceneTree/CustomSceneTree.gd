# Copyright (c) 2022 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
# This file is licensed under the MIT License
# https://github.com/workhorsy/ImmersivePerformance

extends SceneTree
class_name CustomSceneTree

var _immersive_performance = null
var _prev_frame := -1

func _initialize() -> void:
	_immersive_performance = self.current_scene.get_node("/root/ImmersivePerformance")
	_immersive_performance.setup(self)

	print("Custom Scene Tree Initialized")

func _finalize() -> void:
	print("Custom Scene Tree Finalized")

func _idle(delta : float) -> bool:
	var frame := self.get_frame()
	if frame == _prev_frame: return false
	_prev_frame = frame
	if _immersive_performance.is_logging: print("tree process frame:%s ticks:%s" % [frame, OS.get_ticks_msec()])
	return _immersive_performance._idle(delta)

func _iteration(delta : float) -> bool:
	#var _mon = Performance.get_monitor(Performance.TIME_PROCESS) * 1000
	#print(_mon)
	if _immersive_performance.is_logging: print("tree physics frame:%s ticks:%s" % [self.get_frame(), OS.get_ticks_msec()])
	return _immersive_performance._iteration(delta)

func _input_event(_event) -> void:
	pass

