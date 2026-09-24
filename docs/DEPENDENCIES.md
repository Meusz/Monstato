# Dependencias entre Módulos

## Diagrama de Dependencias

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         DEPENDENCY GRAPH                                     │
│                                                                             │
│                           ┌─────────────┐                                   │
│                           │    CORE     │                                   │
│                           │  (Base)     │                                   │
│                           └──────┬──────┘                                   │
│                                  │                                          │
│          ┌───────────────────────┼───────────────────────┐                  │
│          │                       │                       │                  │
│          ▼                       ▼                       ▼                  │
│   ┌─────────────┐        ┌─────────────┐        ┌─────────────┐            │
│   │   SHARED    │        │   SAVE      │        │   AUDIO     │            │
│   │  (Utils)    │        │  (Persist)  │        │  (Sound)    │            │
│   └──────┬──────┘        └─────────────┘        └─────────────┘            │
│          │                                                                  │
│          ├───────────────────────┬───────────────────────┐                  │
│          │                       │                       │                  │
│          ▼                       ▼                       ▼                  │
│   ┌─────────────┐        ┌─────────────┐        ┌─────────────┐            │
│   │   PLAYER    │        │  ENEMIES    │        │   WAVES     │            │
│   │             │        │             │        │             │            │
│   └──────┬──────┘        └──────┬──────┘        └──────┬──────┘            │
│          │                       │                       │                  │
│          │                       │                       │                  │
│          ▼                       ▼                       │                  │
│   ┌─────────────┐        ┌─────────────┐                │                  │
│   │   WEAPONS   │        │   ITEMS     │                │                  │
│   │             │        │             │                │                  │
│   └──────┬──────┘        └──────┬──────┘                │                  │
│          │                       │                       │                  │
│          │                       │                       │                  │
│          ▼                       ▼                       ▼                  │
│   ┌─────────────────────────────────────────────────────────────┐          │
│   │                        ECONOMY                              │          │
│   │  (Currency + Level + Shop)                                  │          │
│   └──────────────────────────┬──────────────────────────────────┘          │
│                              │                                              │
│                              ▼                                              │
│   ┌─────────────────────────────────────────────────────────────┐          │
│   │                          UI                                 │          │
│   │  (HUD + Shop + Upgrade + Pause + MainMenu)                 │          │
│   └─────────────────────────────────────────────────────────────┘          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Dependencias por Módulo

### 1. Core (Sin dependencias)
```
Core
├── No depende de ningún módulo
├── Es la base de todo el sistema
└── Proporciona:
    - GameManager (estado del juego)
    - EventBus (señales)
    - DataBus (datos compartidos)
    - SaveSystem (guardado)
```

### 2. Shared (Depende de Core)
```
Shared ← Core
├── Usa EventBus para señales
├── Usa DataBus para datos
└── Proporciona:
    - Resources (StatModifier, DamageType, Rarity)
    - Components (Hurtbox, Hitbox, Health, Knockback)
    - Utils (Math, Random, Pool)
```

### 3. Player (Depende de Core, Shared)
```
Player ← Core
Player ← Shared
├── Usa EventBus para emitir señales
├── Usa DataBus para leer datos
├── Usa Shared Components
├── Usa Shared Utils
└── Proporciona:
    - Player (nodo principal)
    - PlayerMovement
    - PlayerCombat
    - PlayerStats
    - PlayerAnimations
    - DashAbility
```

### 4. Enemies (Depende de Core, Shared)
```
Enemies ← Core
Enemies ← Shared
├── Usa EventBus para emitir señales
├── Usa DataBus para leer datos
├── Usa Shared Components
├── Usa Shared Utils
└── Proporciona:
    - EnemyBase
    - EnemyIA
    - EnemySpawner
    - EnemyTypes (Melee, Ranged, Tank, Fast, MiniBoss, Boss)
```

### 5. Weapons (Depende de Core, Shared, Player)
```
Weapons ← Core
Weapons ← Shared
Weapons ← Player (para obtener dirección)
├── Usa EventBus para emitir señales
├── Usa Shared Components
├── Usa Shared Utils (Pool)
├── Usa Player para dirección de ataque
└── Proporciona:
    - WeaponBase
    - WeaponManager
    - Projectile
    - WeaponTypes
```

### 6. Items (Depende de Core, Shared)
```
Items ← Core
Items ← Shared
├── Usa EventBus para emitir señales
├── Usa Shared Resources
└── Proporciona:
    - ItemBase
    - PassiveItem
    - Consumable
    - Relic
    - ItemEffects
```

### 7. Waves (Depende de Core, Enemies)
```
Waves ← Core
Waves ← Enemies
├── Usa EventBus para emitir señales
├── Usa EnemySpawner para generar enemigos
├── Usa WaveData (Resource)
└── Proporciona:
    - WaveManager
    - WaveData
    - WaveConfig
```

### 8. Economy (Depende de Core, Items)
```
Economy ← Core
Economy ← Items
├── Usa EventBus para emitir señales
├── Usa Items para inventario
├── Usa ItemDatabase para objetos disponibles
└── Proporciona:
    - CurrencyManager
    - LevelSystem
    - ShopSystem
```

### 9. UI (Depende de Core, Player, Economy)
```
UI ← Core
UI ← Player
UI ← Economy
├── Usa EventBus para escuchar señales
├── Usa Player para mostrar stats
├── Usa Economy para mostrar moneda/XP
└── Proporciona:
    - HUD
    - ShopUI
    - UpgradeUI
    - PauseMenu
    - MainMenu
```

### 10. Effects (Depende de Core)
```
Effects ← Core
├── Usa EventBus para escuchar eventos
├── Usa GameManager para pool de efectos
└── Proporciona:
    - ParticleManager
    - ScreenEffects
    - DamageNumbers
```

### 11. Audio (Depende de Core)
```
Audio ← Core
├── Usa EventBus para escuchar eventos
├── Usa GameManager para control de audio
└── Proporciona:
    - AudioManager
    - MusicManager
    - SFXManager
```

## Reglas de Dependencia

### 1. No Dependencias Circulares
```
❌ MAL:
Player → Weapons → Player

✅ BIEN:
Player → Weapons
Weapons ← Player (solo para obtener datos, no para modificar)
```

### 2. Comunicación por Señales
```
❌ MAL:
# Player accede directamente a Enemy
enemy.take_damage(damage)

✅ BIEN:
# Player emite señal
 EventBus.enemy_damaged.emit(enemy, damage)

# Enemy escucha y se daña
func _on_enemy_damaged(enemy: Enemy, amount: float):
    if enemy == self:
        take_damage(amount)
```

### 3. Datos Compartidos por DataBus
```
❌ MAL:
# Cada módulo guarda sus propios datos
var player_stats = {}
var enemy_stats = {}

✅ BIEN:
# Datos centralizados en DataBus
DataBus.player_stats = player_stats
DataBus.enemy_stats = enemy_stats
```

### 4. Componentes Reutilizables
```
❌ MAL:
# Duplicar lógica en cada enemigo
class MeleeEnemy:
    var health = 100
    func take_damage(amount):
        health -= amount

class RangedEnemy:
    var health = 80
    func take_damage(amount):
        health -= amount

✅ BIEN:
# Usar componente compartido
class EnemyBase:
    @onready var health_component = $HealthComponent

# HealthComponent maneja toda la lógica de salud
```

## flujo de Datos entre Módulos

### Flujo de Combate
```
Player Input → PlayerCombat → WeaponManager → Projectile → Enemy
     │              │              │              │           │
     │              │              │              │           │
     ▼              ▼              ▼              ▼           ▼
  EventBus     EventBus      EventBus       EventBus    EventBus
  .input_      .weapon_      .projectile_   .hit_       .enemy_
  pressed      fired         created        detected    damaged
```

### Flujo de Progresión
```
Enemy Killed → XP Gained → Level Up → Upgrade Choice → Stat Modified
      │            │           │            │              │
      │            │           │            │              │
      ▼            ▼           ▼            ▼              ▼
   EventBus     EventBus    EventBus     EventBus      EventBus
   .enemy_      .xp_        .level_      .upgrade_     .stat_
   killed       gained      up           selected      modified
```

### Flujo de Economía
```
Enemy Killed → Currency Gained → Shop Purchase → Item Equipped → Effect Applied
      │              │               │               │              │
      │              │               │               │              │
      ▼              ▼               ▼               ▼              ▼
   EventBus     EventBus        EventBus        EventBus       EventBus
   .enemy_      .currency_      .item_          .item_         .effect_
   killed       changed         purchased       equipped       applied
```

## Matriz de Dependencias

| Módulo | Core | Shared | Player | Enemies | Weapons | Items | Waves | Economy | UI | Effects | Audio |
|--------|------|--------|--------|---------|---------|-------|-------|---------|----|---------|-------|
| Core | - | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Shared | ✅ | - | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Player | ✅ | ✅ | - | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Enemies | ✅ | ✅ | ❌ | - | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Weapons | ✅ | ✅ | ✅ | ❌ | - | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Items | ✅ | ✅ | ❌ | ❌ | ❌ | - | ❌ | ❌ | ❌ | ❌ | ❌ |
| Waves | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | - | ❌ | ❌ | ❌ | ❌ |
| Economy | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | - | ❌ | ❌ | ❌ |
| UI | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | - | ❌ | ❌ |
| Effects | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | - | ❌ |
| Audio | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | - |

**Leyenda:**
- ✅ = Depende de
- ❌ = No depende de
- ** = Depende indirectamente (a través de otros módulos)

## Autoloads (Singletons)

### Orden de Carga
```
1. EventBus (señales globales)
2. DataBus (datos compartidos)
3. GameManager (estado del juego)
4. AudioManager (audio)
5. SaveSystem (guardado)
```

### Responsabilidades

| Autoload | Responsabilidad | No Debería Hacer |
|----------|-----------------|------------------|
| EventBus | Emitir y recibir señales | Guardar estado |
| DataBus | Almacenar datos compartidos | Emitir señales |
| GameManager | Controlar estado del juego | Almacenar datos específicos |
| AudioManager | Controlar audio | Controlar lógica de juego |
| SaveSystem | Guardar/cargar datos | Controlar estado del juego |

## Convenciones de Dependencia

### 1. Inyección de Dependencias
```gdscript
# ❌ MAL: Depender de autoload directamente
func _ready():
    GameManager.start_game()

# ✅ BIEN: Recibir referencia
func initialize(game_manager: GameManager):
    self.game_manager = game_manager
```

### 2. Señales sobre Llamadas Directas
```gdscript
# ❌ MAL: Llamada directa
enemy.take_damage(damage)

# ✅ BIEN: Señal
EventBus.enemy_damaged.emit(enemy, damage)
```

### 3. Interfaces sobre Implementaciones
```gdscript
# ❌ MAL: Depender de implementación específica
func heal(character: Player):
    character.health += amount

# ✅ BIEN: Depender de interfaz
func heal(character: CharacterWithHealth):
    character.health_component.heal(amount)
```

### 4. Datos sobre Comportamiento
```gdscript
# ❌ MAL: Comportamiento hardcodeado
func get_damage() -> float:
    return 10.0

# ✅ BIEN: Datos configurables
@export var base_damage: float = 10.0
func get_damage() -> float:
    return base_damage * damage_multiplier
```
