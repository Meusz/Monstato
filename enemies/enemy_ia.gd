extends Node

## EnemyIA - Always chases and attacks the player.

enum State { IDLE, SEEK, ATTACK, RECOVER, DEAD }

var current_state: State = State.SEEK
var _enemy: CharacterBody2D
var _attack_timer: float = 0.0
var _recover_timer: float = 0.0

@export var attack_cooldown: float = 1.0
@export var recover_time: float = 0.5

func _ready() -> void:
	_enemy = get_parent() as CharacterBody2D

func _process(delta: float) -> void:
	match current_state:
		State.IDLE:
			_process_idle(delta)
		State.SEEK:
			_process_seek(delta)
		State.ATTACK:
			_process_attack(delta)
		State.RECOVER:
			_process_recover(delta)
		State.DEAD:
			pass

func _process_idle(_delta: float) -> void:
	change_state(State.SEEK)

func _process_seek(_delta: float) -> void:
	var target: Node = _find_player()
	if not target:
		return
	_enemy._target = target
	var distance: float = _enemy.global_position.distance_to(target.global_position)
	var attack_node: Node = _enemy.attack
	if attack_node and distance <= attack_node.attack_range:
		change_state(State.ATTACK)
	else:
		_enemy.movement.move_toward_target(_enemy, target)

func _process_attack(_delta: float) -> void:
	_attack_timer -= _delta
	if _attack_timer <= 0.0:
		_perform_attack()
		change_state(State.RECOVER)

func _process_recover(delta: float) -> void:
	_recover_timer -= delta
	if _recover_timer <= 0.0:
		change_state(State.SEEK)

func _perform_attack() -> void:
	var target: Node = _find_player()
	if not target:
		return
	var attack_node: Node = _enemy.attack
	if not attack_node:
		return
	if _enemy.is_ranged():
		_enemy._perform_ranged_attack()
	else:
		if target.has_node("HealthComponent"):
			var health_comp: HealthComponent = target.get_node("HealthComponent")
			health_comp.take_damage(attack_node.damage, _enemy)
			EventBus.enemy_reached_player.emit(_enemy)

func _find_player() -> Node:
	return get_tree().get_first_node_in_group("player")

func change_state(new_state: State) -> void:
	if new_state == current_state:
		return
	current_state = new_state
	match new_state:
		State.ATTACK:
			_attack_timer = 0.3
		State.RECOVER:
			_recover_timer = recover_time
