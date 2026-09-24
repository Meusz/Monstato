# Lista de Scripts

## Scripts por Módulo

### 1. Core (Núcleo)

| Script | Ruta | Descripción |
|--------|------|-------------|
| game_manager.gd | `res://core/game_manager.gd` | Orquestador principal del juego |
| event_bus.gd | `res://core/event_bus.gd` | Señales globales (autoload) |
| data_bus.gd | `res://core/data_bus.gd` | Datos compartidos (autoload) |
| save_system.gd | `res://core/save_system.gd` | Sistema de guardado |
| game_state.gd | `res://core/game_state.gd` | Enum de estados del juego |

### 2. Player (Jugador)

| Script | Ruta | Descripción |
|--------|------|-------------|
| player.gd | `res://player/player.gd` | Lógica principal del jugador |
| player_movement.gd | `res://player/player_movement.gd` | Movimiento WASD y dash |
| player_combat.gd | `res://player/player_combat.gd` | Gestión de armas y ataque |
| player_stats.gd | `res://player/player_stats.gd` | Estadísticas del jugador |
| player_animations.gd | `res://player/player_animations.gd` | Control de animaciones |
| player_input.gd | `res://player/player_input.gd` | Manejo de input |
| dash_ability.gd | `res://player/dash_ability.gd` | Habilidad de dash |
| player_stats_data.gd | `res://player/stats/player_stats_data.gd` | Resource de stats |

### 3. Enemies (Enemigos)

| Script | Ruta | Descripción |
|--------|------|-------------|
| enemy_base.gd | `res://enemies/enemy_base.gd` | Clase base para enemigos |
| enemy_ia.gd | `res://enemies/enemy_ia.gd` | Máquina de estados IA |
| enemy_spawner.gd | `res://enemies/enemy_spawner.gd` | Sistema de generación |
| enemy_database.gd | `res://enemies/enemy_database.gd` | Base de datos de enemigos |
| enemy_movement.gd | `res://enemies/components/enemy_movement.gd` | Componente de movimiento |
| enemy_attack.gd | `res://enemies/components/enemy_attack.gd` | Componente de ataque |
| enemy_health.gd | `res://enemies/components/enemy_health.gd` | Componente de salud |
| melee_enemy.gd | `res://enemies/types/melee/melee_enemy.gd` | Enemigo melee |
| ranged_enemy.gd | `res://enemies/types/ranged/ranged_enemy.gd` | Enemigo ranged |
| tank_enemy.gd | `res://enemies/types/tank/tank_enemy.gd` | Enemigo tanque |
| fast_enemy.gd | `res://enemies/types/fast/fast_enemy.gd` | Enemigo rápido |
| mini_boss.gd | `res://enemies/types/mini_boss/mini_boss.gd` | Mini jefe |
| boss.gd | `res://enemies/types/boss/boss.gd` | Jefe final |

### 4. Weapons (Armas)

| Script | Ruta | Descripción |
|--------|------|-------------|
| weapon_base.gd | `res://weapons/weapon_base.gd` | Clase base para armas |
| weapon_manager.gd | `res://weapons/weapon_manager.gd` | Gestión de armas equipadas |
| weapon_database.gd | `res://weapons/weapon_database.gd` | Base de datos de armas |
| projectile.gd | `res://weapons/projectile/projectile.gd` | Lógica de proyectil |
| projectile_pool.gd | `res://weapons/projectile/projectile_pool.gd` | Pool de proyectiles |
| pistol.gd | `res://weapons/types/pistol/pistol.gd` | Pistola |
| shotgun.gd | `res://weapons/types/shotgun/shotgun.gd` | Escopeta |
| rifle.gd | `res://weapons/types/rifle/rifle.gd` | Rifle |
| laser.gd | `res://weapons/types/laser/laser.gd` | Láser |

### 5. Items (Objetos)

| Script | Ruta | Descripción |
|--------|------|-------------|
| item_base.gd | `res://items/item_base.gd` | Clase base para objetos |
| item_database.gd | `res://items/item_database.gd` | Base de datos de objetos |
| passive_item.gd | `res://items/passive/passive_item.gd` | Objeto pasivo |
| consumable_item.gd | `res://items/consumable/consumable_item.gd` | Consumible |
| relic_item.gd | `res://items/relic/relic_item.gd` | Reliquia |
| damage_boost_effect.gd | `res://items/passive/types/damage_boost/damage_boost_effect.gd` | Efecto daño |
| speed_boost_effect.gd | `res://items/passive/types/speed_boost/speed_boost_effect.gd` | Efecto velocidad |
| health_boost_effect.gd | `res://items/passive/types/health_boost/health_boost_effect.gd` | Efecto vida |
| health_potion_effect.gd | `res://items/consumable/types/health_potion/health_potion_effect.gd` | Poción vida |
| xp_boost_effect.gd | `res://items/consumable/types/xp_boost/xp_boost_effect.gd` | Efecto XP |
| lucky_coin_effect.gd | `res://items/relic/types/lucky_coin/lucky_coin_effect.gd` | Efecto moneda |
| vampiric_blade_effect.gd | `res://items/relic/types/vampiric_blade/vampiric_blade_effect.gd` | Efecto vampírico |

### 6. Waves (Oleadas)

| Script | Ruta | Descripción |
|--------|------|-------------|
| wave_manager.gd | `res://waves/wave_manager.gd` | Control de oleadas |
| wave_data.gd | `res://waves/wave_data.gd` | Resource de datos de oleada |
| wave_config.gd | `res://waves/wave_config.gd` | Configuración de dificultad |

### 7. UI (Interfaz)

| Script | Ruta | Descripción |
|--------|------|-------------|
| hud.gd | `res://ui/hud/hud.gd` | Lógica del HUD |
| health_bar.gd | `res://ui/hud/health_bar.gd` | Barra de vida |
| xp_bar.gd | `res://ui/hud/xp_bar.gd` | Barra de experiencia |
| wave_timer.gd | `res://ui/hud/wave_timer.gd` | Timer de oleada |
| currency_display.gd | `res://ui/hud/currency_display.gd` | Muestra de moneda |
| weapon_slots.gd | `res://ui/hud/weapon_slots.gd` | Slots de armas |
| shop_ui.gd | `res://ui/shop/shop_ui.gd` | Interfaz de tienda |
| shop_item_slot.gd | `res://ui/shop/shop_item_slot.gd` | Slot de objeto en tienda |
| shop_refresh_button.gd | `res://ui/shop/shop_refresh_button.gd` | Botón de refrescar |
| upgrade_ui.gd | `res://ui/upgrade/upgrade_ui.gd` | Selección de mejoras |
| upgrade_card.gd | `res://ui/upgrade/upgrade_card.gd` | Tarjeta de mejora |
| pause_menu.gd | `res://ui/pause/pause_menu.gd` | Menú de pausa |
| main_menu.gd | `res://ui/main_menu/main_menu.gd` | Menú principal |

### 8. Economy (Economía)

| Script | Ruta | Descripción |
|--------|------|-------------|
| currency_manager.gd | `res://economy/currency_manager.gd` | Gestión de moneda y XP |
| level_system.gd | `res://economy/level_system.gd` | Sistema de niveles |
| shop_system.gd | `res://economy/shop_system.gd` | Lógica de tienda |

### 9. Effects (Efectos)

| Script | Ruta | Descripción |
|--------|------|-------------|
| particle_manager.gd | `res://effects/particle_manager.gd` | Gestión de partículas |
| screen_effects.gd | `res://effects/screen_effects.gd` | Efectos de pantalla |
| damage_number.gd | `res://effects/damage_numbers/damage_number.gd` | Número de daño |

### 10. Audio (Audio)

| Script | Ruta | Descripción |
|--------|------|-------------|
| audio_manager.gd | `res://audio/audio_manager.gd` | Gestión principal de audio |
| music_manager.gd | `res://audio/music_manager.gd` | Gestión de música |
| sfx_manager.gd | `res://audio/sfx_manager.gd` | Gestión de efectos de sonido |

### 11. Save (Guardado)

| Script | Ruta | Descripción |
|--------|------|-------------|
| save_data.gd | `res://save/save_data.gd` | Estructura de datos guardados |
| save_manager.gd | `res://save/save_manager.gd` | Gestión de guardado |
| unlock_database.gd | `res://save/unlocks/unlock_database.gd` | Base de datos de desbloqueos |

### 12. Shared (Compartido)

| Script | Ruta | Descripción |
|--------|------|-------------|
| stat_modifier.gd | `res://shared/resources/stat_modifier.gd` | Resource de modificador de stat |
| damage_type.gd | `res://shared/resources/damage_type.gd` | Enum de tipos de daño |
| rarity.gd | `res://shared/resources/rarity.gd` | Enum de rareza |
| hurtbox_component.gd | `res://shared/components/hurtbox_component.gd` | Componente hurtbox |
| hitbox_component.gd | `res://shared/components/hitbox_component.gd` | Componente hitbox |
| health_component.gd | `res://shared/components/health_component.gd` | Componente de salud |
| knockback_component.gd | `res://shared/components/knockback_component.gd` | Componente de knockback |
| math_utils.gd | `res://shared/utils/math_utils.gd` | Utilidades matemáticas |
| random_utils.gd | `res://shared/utils/random_utils.gd` | Utilidades aleatorias |
| pool_utils.gd | `res://shared/utils/pool_utils.gd` | Utilidades de pooling |

## Scripts de Autoload (Singletons)

| Script | Nombre | Prioridad |
|--------|--------|-----------|
| event_bus.gd | EventBus | 1 |
| data_bus.gd | DataBus | 2 |
| game_manager.gd | GameManager | 3 |
| audio_manager.gd | AudioManager | 4 |
| save_system.gd | SaveSystem | 5 |

## Scripts de Configuración

| Script | Ruta | Descripción |
|--------|------|-------------|
| project_settings.gd | `res://core/project_settings.gd` | Configuración del proyecto |
| input_map.gd | `res://core/input_map.gd` | Mapeo de input |

## Scripts de Utilidad

| Script | Ruta | Descripción |
|--------|------|-------------|
| math_utils.gd | `res://shared/utils/math_utils.gd` | Funciones matemáticas |
| random_utils.gd | `res://shared/utils/random_utils.gd` | Generación aleatoria |
| pool_utils.gd | `res://shared/utils/pool_utils.gd` | Object pooling |
| timer_utils.gd | `res://shared/utils/timer_utils.gd` | Utilidades de tiempo |
| node_utils.gd | `res://shared/utils/node_utils.gd` | Utilidades de nodos |

## Convenciones de Nomenclatura

### Archivos
- Scripts: `snake_case.gd`
- Escenas: `PascalCase.tscn`
- Recursos: `PascalCase.tres`
- Carpetas: `snake_case/`

### Clases
- Clases: `PascalCase`
- Enums: `PascalCase`
- Constantes: `UPPER_SNAKE_CASE`

### Variables
- Variables: `snake_case`
- Variables privadas: `_snake_case`
- Señales: `snake_case`
- Funciones: `snake_case`

### Exported
- `@export var property_name: Type`
- `@export_range(min, max) var property_name: Type`
- `@export_enum("Option1", "Option2") var property_name: String`
