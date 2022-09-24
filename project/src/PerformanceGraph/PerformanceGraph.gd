# Copyright (c) 2022 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
# This file is licensed under the MIT License
# https://github.com/workhorsy/ImmersivePerformance

extends Node2D


onready var _line_base := $LineBase
onready var _line_physics := $LinePhysics
onready var _line_process := $LineProcess
onready var _line_deferred := $LineDeferred
onready var _line_render := $LineRender

var _offset := 0.0
func update() -> void:
	var scale := 6.0
	var x := 0.0
	var y := 0.0

	if _line_base.get_point_count() > 120:
		_line_base.remove_point(0)
	x = _offset
	y = 0
	_line_base.add_point(Vector2(x, y) * scale)
	_line_base.transform.origin.x -= 1.0 * scale

	if _line_physics.get_point_count() > 120:
		_line_physics.remove_point(0)
	x = _offset
	y = -ImmersivePerformance._physics_used_msec
	_line_physics.add_point(Vector2(x, y) * scale)
	_line_physics.transform.origin.x -= 1.0 * scale
	$LabelPhysics.text = "Physics: %s ms" % [ImmersivePerformance._physics_used_msec]

	if _line_process.get_point_count() > 120:
		_line_process.remove_point(0)
	x = _offset
	y = -ImmersivePerformance._process_used_msec
	_line_process.add_point(Vector2(x, y) * scale)
	_line_process.transform.origin.x -= 1.0 * scale
	$LabelProcess.text = "Process: %s ms" % [ImmersivePerformance._process_used_msec]

	if _line_deferred.get_point_count() > 120:
		_line_deferred.remove_point(0)
	x = _offset
	y = -ImmersivePerformance._deferred_used_msec
	_line_deferred.add_point(Vector2(x, y) * scale)
	_line_deferred.transform.origin.x -= 1.0 * scale
	$LabelDeferred.text = "Deferred: %s ms" % [ImmersivePerformance._deferred_used_msec]

	if _line_render.get_point_count() > 120:
		_line_render.remove_point(0)
	x = _offset
	y = -ImmersivePerformance._draw_used_msec
	_line_render.add_point(Vector2(x, y) * scale)
	_line_render.transform.origin.x -= 1.0 * scale
	$LabelRender.text = "Render: %s ms" % [ImmersivePerformance._draw_used_msec]

	_offset += 1.0
