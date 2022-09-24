# Copyright (c) 2022 Matthew Brennan Jones <matthew.brennan.jones@gmail.com>
# This file is licensed under the MIT License
# https://github.com/workhorsy/ImmersivePerformance


extends Spatial

var _ball_scene := preload("res://src/Ball/Ball.tscn")
var _balls := []

var _rng : RandomNumberGenerator
var _fps_timer : Timer
var _is_holding_add_ball := false
var _is_blocking_physics := false
var _is_blocking_process := false
var _prev_frame := -1

func _ready() -> void:
	# Setup random number generator
	_rng = RandomNumberGenerator.new()
	_rng.randomize()

	# Show FPS in the title
	_fps_timer = Timer.new()
	self.add_child(_fps_timer)
	var err := _fps_timer.connect("timeout", self, "_on_fps_timeout")
	assert(err == OK)
	_fps_timer.set_wait_time(0.1)
	_fps_timer.set_one_shot(false)
	_fps_timer.start()
	self._on_fps_timeout()

func _on_fps_timeout() -> void:
	var fps := Engine.get_frames_per_second()
	var title := "FPS: %s, Balls: %s" % [fps, _balls.size()]
	OS.set_window_title(title)

func _process(_delta : float) -> void:
	var frame := self.get_tree().get_frame()
	if frame == _prev_frame: return
	_prev_frame = frame


#	if true:
#		var start := OS.get_ticks_msec()
#		var end := OS.get_ticks_msec()
#		while end - start < 20:
#			end = OS.get_ticks_msec()

	if ImmersivePerformance.is_logging: print("world process frame:%s ticks:%s" % [frame, OS.get_ticks_msec()])
	if _is_holding_add_ball:
		for i in 10:
			var ball = _ball_scene.instance()
			self.add_child(ball)
			ball.transform.origin += Vector3(_rng.randf_range(-50.0, 50.0), _rng.randf_range(-50.0, 50.0), _rng.randf_range(-50.0, 50.0))
			_balls.append(ball)

	if _is_blocking_process:
		print("process !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! frame:%s" % [self.get_tree().get_frame()])
		_is_blocking_process = false
		var start := OS.get_ticks_msec()
		var end := OS.get_ticks_msec()
		while end - start < 2000:
			end = OS.get_ticks_msec()
		#print("Done")

func _physics_process(_delta : float) -> void:
	if ImmersivePerformance.is_logging: print("world physics frame:%s ticks:%s" % [self.get_tree().get_frame(), OS.get_ticks_msec()])
	if _is_blocking_physics:
		print("physics !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! frame:%s" % [self.get_tree().get_frame()])
		_is_blocking_physics = false
		var start := OS.get_ticks_msec()
		var end := OS.get_ticks_msec()
		while end - start < 2000:
			end = OS.get_ticks_msec()
		#print("Done")

func _block_call_deferred() -> void:
	print("deferred !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! frame:%s" % [self.get_tree().get_frame()])
	var start := OS.get_ticks_msec()
	var end := OS.get_ticks_msec()
	while end - start < 2000:
		end = OS.get_ticks_msec()
	#print("Done")

func _input(_event : InputEvent) -> void:
	pass

func _on_ButtonAddPhysicsBody_button_down() -> void:
	_is_holding_add_ball = true

func _on_ButtonAddPhysicsBody_button_up() -> void:
	_is_holding_add_ball = false

func _on_ButtonBlockPhysicsProcess_pressed() -> void:
	_is_blocking_physics = true

func _on_ButtonBlockProcess_pressed() -> void:
	_is_blocking_process = true


func _on_ButtonBlockDeferred_pressed() -> void:
	self.call_deferred("_block_call_deferred")
