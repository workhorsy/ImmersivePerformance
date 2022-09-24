# Copyright (c) 2022 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
# This file is licensed under the MIT License
# https://github.com/workhorsy/ImmersivePerformance

extends Spatial


onready var _graph := $PerformanceGraph

func update() -> void:
	_graph.update()
