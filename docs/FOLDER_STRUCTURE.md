# Árbol de Carpetas del Proyecto

```
roguelite_survivor/
├── project.godot
├── .godot/
├── .gitignore
├── .git/
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── FOLDER_STRUCTURE.md
│   ├── SYSTEMS_DIAGRAM.md
│   ├── SCENES_LIST.md
│   ├── SCRIPTS_LIST.md
│   └── DEPENDENCIES.md
│
├── core/
│   ├── game_manager.gd
│   ├── event_bus.gd
│   ├── data_bus.gd
│   ├── save_system.gd
│   └── game_state.gd
│
├── player/
│   ├── player.tscn
│   ├── player.gd
│   ├── player_movement.gd
│   ├── player_combat.gd
│   ├── player_stats.gd
│   ├── player_animations.gd
│   ├── player_input.gd
│   ├── dash_ability.gd
│   └── stats/
│       ├── player_stats_data.tres
│       └── player_stats_data.gd
│
├── enemies/
│   ├── enemy_base.tscn
│   ├── enemy_base.gd
│   ├── enemy_ia.gd
│   ├── enemy_spawner.gd
│   ├── enemy_database.gd
│   ├── components/
│   │   ├── enemy_movement.gd
│   │   ├── enemy_attack.gd
│   │   └── enemy_health.gd
│   ├── types/
│   │   ├── melee/
│   │   │   ├── melee_enemy.tscn
│   │   │   └── melee_enemy.gd
│   │   ├── ranged/
│   │   │   ├── ranged_enemy.tscn
│   │   │   └── ranged_enemy.gd
│   │   ├── tank/
│   │   │   ├── tank_enemy.tscn
│   │   │   └── tank_enemy.gd
│   │   ├── fast/
│   │   │   ├── fast_enemy.tscn
│   │   │   └── fast_enemy.gd
│   │   ├── mini_boss/
│   │   │   ├── mini_boss.tscn
│   │   │   └── mini_boss.gd
│   │   └── boss/
│   │       ├── boss.tscn
│   │       └── boss.gd
│   └── data/
│       ├── melee_enemy_data.tres
│       ├── ranged_enemy_data.tres
│       ├── tank_enemy_data.tres
│       ├── fast_enemy_data.tres
│       ├── mini_boss_data.tres
│       └── boss_data.tres
│
├── weapons/
│   ├── weapon_base.gd
│   ├── weapon_manager.gd
│   ├── weapon_database.gd
│   ├── projectile/
│   │   ├── projectile.tscn
│   │   ├── projectile.gd
│   │   └── projectile_pool.gd
│   ├── types/
│   │   ├── pistol/
│   │   │   ├── pistol.tscn
│   │   │   └── pistol.gd
│   │   ├── shotgun/
│   │   │   ├── shotgun.tscn
│   │   │   └── shotgun.gd
│   │   ├── rifle/
│   │   │   ├── rifle.tscn
│   │   │   └── rifle.gd
│   │   └── laser/
│   │       ├── laser.tscn
│   │       └── laser.gd
│   └── data/
│       ├── pistol_data.tres
│       ├── shotgun_data.tres
│       ├── rifle_data.tres
│       └── laser_data.tres
│
├── items/
│   ├── item_base.gd
│   ├── item_database.gd
│   ├── passive/
│   │   ├── passive_item.tscn
│   │   ├── passive_item.gd
│   │   └── types/
│   │       ├── damage_boost/
│   │       │   ├── damage_boost.tres
│   │       │   └── damage_boost_effect.gd
│   │       ├── speed_boost/
│   │       │   ├── speed_boost.tres
│   │       │   └── speed_boost_effect.gd
│   │       └── health_boost/
│   │           ├── health_boost.tres
│   │           └── health_boost_effect.gd
│   ├── consumable/
│   │   ├── consumable_item.tscn
│   │   ├── consumable_item.gd
│   │   └── types/
│   │       ├── health_potion/
│   │       │   ├── health_potion.tres
│   │       │   └── health_potion_effect.gd
│   │       └── xp_boost/
│   │           ├── xp_boost.tres
│   │           └── xp_boost_effect.gd
│   └── relic/
│       ├── relic_item.tscn
│       ├── relic_item.gd
│       └── types/
│           ├── lucky_coin/
│           │   ├── lucky_coin.tres
│           │   └── lucky_coin_effect.gd
│           └── vampiric_blade/
│               ├── vampiric_blade.tres
│               └── vampiric_blade_effect.gd
│
├── waves/
│   ├── wave_manager.gd
│   ├── wave_data.gd
│   ├── wave_config.gd
│   └── data/
│       ├── wave_01.tres
│       ├── wave_02.tres
│       ├── wave_03.tres
│       └── wave_04.tres
│
├── ui/
│   ├── hud/
│   │   ├── hud.tscn
│   │   ├── hud.gd
│   │   ├── health_bar.gd
│   │   ├── xp_bar.gd
│   │   ├── wave_timer.gd
│   │   ├── currency_display.gd
│   │   └── weapon_slots.gd
│   ├── shop/
│   │   ├── shop_ui.tscn
│   │   ├── shop_ui.gd
│   │   ├── shop_item_slot.gd
│   │   └── shop_refresh_button.gd
│   ├── upgrade/
│   │   ├── upgrade_ui.tscn
│   │   ├── upgrade_ui.gd
│   │   └── upgrade_card.gd
│   ├── pause/
│   │   ├── pause_menu.tscn
│   │   └── pause_menu.gd
│   └── main_menu/
│       ├── main_menu.tscn
│       └── main_menu.gd
│
├── economy/
│   ├── currency_manager.gd
│   ├── level_system.gd
│   └── shop_system.gd
│
├── effects/
│   ├── particle_manager.gd
│   ├── screen_effects.gd
│   └── damage_numbers/
│       ├── damage_number.tscn
│       └── damage_number.gd
│
├── audio/
│   ├── audio_manager.gd
│   ├── music_manager.gd
│   ├── sfx_manager.gd
│   └── buses/
│       └── audio_bus_layout.tres
│
├── save/
│   ├── save_data.gd
│   ├── save_manager.gd
│   └── unlocks/
│       └── unlock_database.gd
│
├── maps/
│   ├── arena/
│   │   ├── arena.tscn
│   │   └── arena.gd
│   └── backgrounds/
│       └── default_background.tres
│
├── shared/
│   ├── resources/
│   │   ├── stat_modifier.gd
│   │   ├── damage_type.gd
│   │   └── rarity.gd
│   ├── components/
│   │   ├── hurtbox_component.gd
│   │   ├── hitbox_component.gd
│   │   ├── health_component.gd
│   │   └── knockback_component.gd
│   └── utils/
│       ├── math_utils.gd
│       ├── random_utils.gd
│       └── pool_utils.gd
│
└── assets/
    ├── sprites/
    │   ├── player/
    │   ├── enemies/
    │   ├── weapons/
    │   ├── items/
    │   └── ui/
    ├── animations/
    │   ├── player/
    │   ├── enemies/
    │   └── weapons/
    ├── audio/
    │   ├── music/
    │   └── sfx/
    ├── fonts/
    └── particles/
        ├── hit_effect.tres
        ├── death_effect.tres
        └── level_up_effect.tres
```

## Estructura por Módulos

### Módulo Core
```
core/
├── game_manager.gd      # Orquestador principal
├── event_bus.gd         # Señales globales
├── data_bus.gd          # Datos compartidos
├── save_system.gd       # Persistencia
└── game_state.gd        # Estados del juego
```

### Módulo Player
```
player/
├── player.tscn          # Escena principal
├── player.gd            # Lógica principal
├── player_movement.gd   # Movimiento WASD + Dash
├── player_combat.gd     # Gestión de armas
├── player_stats.gd      # Estadísticas
├── player_animations.gd # Animaciones
├── player_input.gd      # Input del jugador
├── dash_ability.gd      # Habilidad de dash
└── stats/
    ├── player_stats_data.tres  # Datos iniciales
    └── player_stats_data.gd    # Resource de stats
```

### Módulo Enemies
```
enemies/
├── enemy_base.tscn      # Escena base
├── enemy_base.gd        # Lógica base
├── enemy_ia.gd          # Máquina de estados
├── enemy_spawner.gd     # Sistema de spawn
├── enemy_database.gd    # Base de datos
├── components/          # Componentes reutilizables
│   ├── enemy_movement.gd
│   ├── enemy_attack.gd
│   └── enemy_health.gd
├── types/               # Tipos de enemigos
│   ├── melee/
│   ├── ranged/
│   ├── tank/
│   ├── fast/
│   ├── mini_boss/
│   └── boss/
└── data/                # Resources de datos
```

### Módulo Weapons
```
weapons/
├── weapon_base.gd       # Clase base
├── weapon_manager.gd    # Gestión de armas
├── weapon_database.gd   # Base de datos
├── projectile/          # Sistema de proyectiles
│   ├── projectile.tscn
│   ├── projectile.gd
│   └── projectile_pool.gd
├── types/               # Tipos de armas
│   ├── pistol/
│   ├── shotgun/
│   ├── rifle/
│   └── laser/
└── data/                # Resources de datos
```

### Módulo Items
```
items/
├── item_base.gd         # Clase base
├── item_database.gd     # Base de datos
├── passive/             # Objetos pasivos
├── consumable/          # Consumibles
└── relic/               # Reliquias
```

### Módulo Waves
```
waves/
├── wave_manager.gd      # Control de oleadas
├── wave_data.gd         # Resource de datos
├── wave_config.gd       # Configuración
└── data/                # Resources de oleadas
```

### Módulo UI
```
ui/
├── hud/                 # Interfaz durante juego
├── shop/                # Interfaz de tienda
├── upgrade/             # Selección de mejoras
├── pause/               # Menú de pausa
└── main_menu/           # Menú principal
```

### Módulo Economy
```
economy/
├── currency_manager.gd  # Moneda y XP
├── level_system.gd      # Sistema de niveles
└── shop_system.gd       # Lógica de tienda
```

### Módulo Effects
```
effects/
├── particle_manager.gd  # Gestión de partículas
├── screen_effects.gd    # Efectos de pantalla
└── damage_numbers/      # Números de daño
```

### Módulo Audio
```
audio/
├── audio_manager.gd     # Gestión principal
├── music_manager.gd     # Música
├── sfx_manager.gd       # Efectos de sonido
└── buses/               # Configuración de audio
```

### Módulo Save
```
save/
├── save_data.gd         # Estructura de datos
├── save_manager.gd      # Gestión de guardado
└── unlocks/             # Desbloqueos
```

### Módulo Shared
```
shared/
├── resources/           # Resources comunes
├── components/          # Componentes reutilizables
└── utils/               # Utilidades
```
