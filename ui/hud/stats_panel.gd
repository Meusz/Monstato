extends CanvasLayer

## StatsPanel - Shows all player stats on the right side.

@onready var hp_label: Label = $PanelContainer/VBox/HP
@onready var regen_label: Label = $PanelContainer/VBox/Regen
@onready var life_steal_label: Label = $PanelContainer/VBox/LifeSteal
@onready var damage_label: Label = $PanelContainer/VBox/Damage
@onready var melee_label: Label = $PanelContainer/VBox/Melee
@onready var ranged_label: Label = $PanelContainer/VBox/Ranged
@onready var elem_label: Label = $PanelContainer/VBox/Elemental
@onready var atk_spd_label: Label = $PanelContainer/VBox/AttackSpeed
@onready var crit_label: Label = $PanelContainer/VBox/Crit
@onready var engi_label: Label = $PanelContainer/VBox/Engineering
@onready var range_label: Label = $PanelContainer/VBox/Range
@onready var armor_label: Label = $PanelContainer/VBox/Armor
@onready var dodge_label: Label = $PanelContainer/VBox/Dodge
@onready var speed_label: Label = $PanelContainer/VBox/Speed
@onready var luck_label: Label = $PanelContainer/VBox/Luck
@onready var harvest_label: Label = $PanelContainer/VBox/Harvesting
@onready var curse_label: Label = $PanelContainer/VBox/Curse
@onready var level_label: Label = $PanelContainer/VBox/Level
@onready var kills_label: Label = $PanelContainer/VBox/Kills
@onready var wave_label: Label = $PanelContainer/VBox/Wave
@onready var time_label: Label = $PanelContainer/VBox/Time

func _ready() -> void:
	_update_all()

func _process(_delta: float) -> void:
	_update_all()

func _update_all() -> void:
	var s: Dictionary = DataBus.player_stats
	hp_label.text = "Max HP: %d" % int(s.get("max_health", 100.0))
	regen_label.text = "Regen: %.1f" % s.get("regeneration", 0.0)
	life_steal_label.text = "Life Steal: %d%%" % int(s.get("life_steal", 0.0) * 100.0)
	damage_label.text = "Damage: +%d%%" % int(s.get("damage", 0.0))
	melee_label.text = "Melee: +%d" % int(s.get("melee_damage", 0.0))
	ranged_label.text = "Ranged: +%d" % int(s.get("ranged_damage", 0.0))
	elem_label.text = "Elemental: +%d" % int(s.get("elemental_damage", 0.0))
	atk_spd_label.text = "Atk Speed: +%d%%" % int(s.get("attack_speed", 0.0))
	crit_label.text = "Crit: %d%%" % int(s.get("crit_chance", 0.05) * 100.0)
	engi_label.text = "Engineering: %d" % int(s.get("engineering", 0.0))
	range_label.text = "Range: +%d%%" % int(s.get("range", 0.0))
	armor_label.text = "Armor: %d" % int(s.get("armor", 0.0))
	dodge_label.text = "Dodge: %d%%" % mini(int(s.get("dodge", 0.0) * 100.0), 60)
	speed_label.text = "Speed: %d" % int(s.get("speed", 200.0))
	luck_label.text = "Luck: %d" % int(s.get("luck", 0.0))
	harvest_label.text = "Harvesting: %d" % int(s.get("harvesting", 0.0))
	curse_label.text = "Curse: %d" % int(s.get("curse", 0.0))
	level_label.text = "Companions: %d" % DataBus.owned_companions.size()
	kills_label.text = "Kills: %d" % DataBus.total_enemies_killed
	wave_label.text = "Wave: %d" % DataBus.current_wave
	var t: float = GameManager.get_run_time()
	time_label.text = "Time: %02d:%02d" % [int(t) / 60, int(t) % 60]
