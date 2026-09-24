extends Node

## EventBus - Global signal bus for decoupled communication.
## All systems communicate through this bus instead of direct references.

# Game Signals
signal game_started
signal game_paused(is_paused: bool)
signal game_over(victory: bool)
signal scene_change_requested(scene_path: String)
signal player_revived
signal ad_rewarded(reward_name: String, reward_amount: int)

# Wave Signals
signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal wave_timer_updated(time_remaining: float)

# Player Signals
signal player_damaged(amount: float, source: Node)
signal player_healed(amount: float)
signal player_dodged
signal player_died
signal player_leveled_up(new_level: int)
signal player_xp_gained(amount: int)
signal dash_used
signal ability_requested
signal weapon_changed(weapon_index: int, weapon_data: Resource)
signal companion_added(companion_data: CompanionData)
signal companion_removed(companion_key: String)
signal companion_team_changed
signal companion_leveled_up(companion_name: String, new_level: int)

# Enemy Signals
signal enemy_spawned(enemy: Node)
signal enemy_damaged(enemy: Node, amount: float, is_critical: bool)
signal enemy_killed(enemy: Node, xp_value: int)
signal enemy_reached_player(enemy: Node)
signal boss_spawned(boss: Node)
signal boss_defeated(boss: Node)

# Combat Signals
signal weapon_fired(weapon: Node, projectile_count: int)
signal projectile_hit(target: Node, damage: float, position: Vector2)
signal damage_dealt(target: Node, amount: float, damage_type: int)
signal critical_hit(target: Node, amount: float)
signal knockback_applied(target: Node, direction: Vector2, force: float)

# Status Effect Signals
signal status_effect_applied(target: Node, effect_type: String, duration: float)
signal status_effect_removed(target: Node, effect_type: String)

# Economy Signals
signal currency_changed(new_amount: int)
signal currency_earned(amount: int)
signal currency_spent(amount: int)
signal xp_gained(amount: int)
signal level_up(new_level: int)
signal item_purchased(item: Resource, cost: int)
signal item_sold(item: Resource, refund: int)
signal shop_refreshed

# Item Signals
signal item_collected(item: Resource)
signal item_equipped(item: Resource)
signal item_unequipped(item: Resource)
signal passive_effect_applied(item: Resource)
signal consumable_used(item: Resource)

# Upgrade Signals
signal upgrade_offered(upgrades: Array)
signal upgrade_selected(upgrade: Resource)
signal upgrade_completed

# UI Signals
signal shop_opened
signal shop_closed
signal pause_toggled(is_paused: bool)
signal menu_navigate(menu_name: String)
signal settings_changed

# Ability Signals
signal ability_used(ability_name: String)

# Audio Signals
signal sfx_requested(sfx_name: String)
signal music_requested(track_name: String)
signal music_stop_requested
signal volume_changed(bus_name: String, volume: float)
