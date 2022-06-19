# Copyright (c) 2022 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
# This file is licensed under the MIT License
# https://github.com/workhorsy/ImmersivePerformance

extends Node

var _physics_start_msec := 0
var _physics_end_msec := 0
var _physics_used_msec := 0

var _process_start_msec := 0
var _process_end_msec := 0
var _process_used_msec := 0

var _deferred_start_msec := 0
var _deferred_end_msec := 0
var _deferred_used_msec := 0

var _draw_start_msec := 0
var _draw_end_msec := 0
var _draw_used_msec := 0

var _frame_used_msec := 0

var _loads := PoolIntArray()
var _loads_index := 0
var _loads_total := 0

var _first_node : Node = null
var _last_node : Node = null
var _first_node_scene := preload("res://addons/immersive_performance/Performance/FirstNode.tscn")
var _last_node_scene := preload("res://addons/immersive_performance/Performance/LastNode.tscn")

var _scene_tree = null
var _is_setup := false
var is_logging := false

func setup(scene_tree : SceneTree) -> void:
	_scene_tree = scene_tree
	_loads.resize(120)
	_loads.fill(0)

	VisualServer.connect("frame_pre_draw", self, "_on_pre_draw")
	VisualServer.connect("frame_post_draw", self, "_on_post_draw")

	_is_setup = true

func _on_pre_draw() -> void:
	_draw_start_msec = OS.get_ticks_msec()
	if ImmersivePerformance.is_logging: print("first render frame:%s ticks:%s" % [self.get_tree().get_frame(), OS.get_ticks_msec()])

func _on_post_draw() -> void:
	_draw_end_msec = OS.get_ticks_msec()
	_draw_used_msec = _draw_end_msec - _draw_start_msec
	if ImmersivePerformance.is_logging: print("last render frame:%s ticks:%s" % [self.get_tree().get_frame(), OS.get_ticks_msec()])

	# FIXME: Move to first node physics run, because render does not always happen, and physics always does
	self._on_calculate_totals()
	self.get_tree().current_scene.update()

# Called before running all deferred and node _process functions
func _idle(_delta : float) -> bool:
	if not _is_setup: return false

	return false

# Called before running all node _physics_process functions
func _iteration(_delta : float) -> bool:
	if not _is_setup: return false

#	# Reset the frame data
#	_process_start_msec = 0
#	_process_end_msec = 0
#	_physics_start_msec = 0
#	_physics_end_msec = 0

	var target = _scene_tree.current_scene
	if not target: return false

	# Forget first and last node if they have been freed
	if not is_instance_valid(_first_node):
		_first_node = null
	if not is_instance_valid(_last_node):
		_last_node = null

	# Create first and last nodes in tree
	if not _first_node:
		_first_node = _first_node_scene.instance()
		target.add_child(_first_node)
	if not _last_node:
		_last_node = _last_node_scene.instance()
		target.add_child(_last_node)

	# Move first node to be first in tree
	if _first_node.get_index() != 0:
		_first_node.get_parent().move_child(_first_node, 0)
	# Move last node to be last in tree
	if _last_node.get_index() != target.get_child_count()-1:
		_last_node.get_parent().move_child(_last_node, target.get_child_count()-1)

	return false

func _on_first_node_physics_process() -> void:
	_physics_start_msec = OS.get_ticks_msec()

func _on_first_node_process() -> void:
	_deferred_end_msec = OS.get_ticks_msec()
	_process_start_msec = _deferred_end_msec

func _on_last_node_physics_process() -> void:
	_physics_end_msec = OS.get_ticks_msec()
	_deferred_start_msec = OS.get_ticks_msec()

func _on_last_node_process() -> void:
	_process_end_msec = OS.get_ticks_msec()

func _on_calculate_totals() -> void:
	# Total time used for physics, process, and deferred
	_physics_used_msec = _physics_end_msec - _physics_start_msec
	_process_used_msec = _process_end_msec - _process_start_msec
	_deferred_used_msec = _deferred_end_msec - _deferred_start_msec
	_frame_used_msec = _physics_used_msec + _process_used_msec + _deferred_used_msec + _draw_used_msec
	#if _frame_used_msec > 2:
	print("phy %s pro %s def %s ren %s" % [_physics_used_msec, _process_used_msec, _deferred_used_msec, _draw_used_msec])

	# Calculate the average load
	_loads_total -= _loads[_loads_index]
	_loads_total += _frame_used_msec
	_loads[_loads_index] = _frame_used_msec
	_loads_index += 1
	if _loads_index > _loads.size()-1:
		_loads_index = 0
	var average_load := float(_loads_total) / _loads.size()
	#print(average_load)
