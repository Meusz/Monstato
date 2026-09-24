class_name PoolUtils
extends RefCounted

## Generic object pooling utility.
## Reuse pre-allocated objects to avoid runtime instantiation.

var _pool: Array = []
var _active: Array = []
var _inactive: Array = []
var _scene: PackedScene
var _parent: Node

## Initializes the pool with a given scene and pre-allocated count.
func initialize(scene: PackedScene, parent: Node, count: int) -> void:
	_scene = scene
	_parent = parent
	for i in count:
		var instance := _create_instance()
		instance.set_process(false)
		instance.set_physics_process(false)
		if instance is Node2D:
			instance.visible = false
		_pool.append(instance)
		_inactive.append(instance)

## Gets an inactive object from the pool, activates it, and returns it.
func get_object() -> Node:
	var obj: Node
	if not _inactive.is_empty():
		obj = _inactive.pop_back()
	else:
		obj = _create_instance()
	_active.append(obj)
	_activate_object(obj)
	return obj

## Returns an object to the pool (deactivates it).
func release(obj: Node) -> void:
	if obj in _active:
		_active.erase(obj)
	_deactivate_object(obj)
	_inactive.append(obj)

## Returns all active objects to the pool.
func release_all() -> void:
	while not _active.is_empty():
		var obj: Node = _active.pop_back()
		_deactivate_object(obj)
		_inactive.append(obj)

## Returns the number of active objects.
func get_active_count() -> int:
	return _active.size()

## Returns the number of inactive objects.
func get_inactive_count() -> int:
	return _inactive.size()

## Returns the total pool size.
func get_total_count() -> int:
	return _pool.size()

## Returns all active objects.
func get_active_objects() -> Array:
	return _active

## Resizes the pool. Adds more objects if needed.
func resize(new_size: int) -> void:
	while _pool.size() < new_size:
		var instance := _create_instance()
		instance.set_process(false)
		instance.set_physics_process(false)
		if instance is Node2D:
			instance.visible = false
		_pool.append(instance)
		_inactive.append(instance)

## Creates a new instance from the scene.
func _create_instance() -> Node:
	var instance := _scene.instantiate()
	_parent.add_child(instance)
	return instance

## Activates an object.
func _activate_object(obj: Node) -> void:
	obj.set_process(true)
	obj.set_physics_process(true)
	if obj is Node2D:
		obj.visible = true
	if obj.has_method("activate"):
		obj.activate()

## Deactivates an object.
func _deactivate_object(obj: Node) -> void:
	obj.set_process(false)
	obj.set_physics_process(false)
	if obj is Node2D:
		obj.visible = false
	if obj.has_method("deactivate"):
		obj.deactivate()

## Destroys the pool and frees all objects.
func destroy() -> void:
	for obj in _pool:
		if is_instance_valid(obj):
			obj.queue_free()
	_pool.clear()
	_active.clear()
	_inactive.clear()
