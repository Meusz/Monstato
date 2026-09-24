# Arquitectura del Proyecto - Roguelite de Supervivencia

## Visión General

Roguelite de supervivencia con partidas de 20-30 minutos. El jugador enfrenta oleadas de enemigos mientras mejora su personaje mediante decisiones estratégicas. Diseñado para ser extremadamente adictivo, con código limpio y arquitectura escalable.

## Principios de Diseño

1. **Composición sobre herencia** - Usar nodos y componentes, no clases profundas
2. **Separación de responsabilidades** - Cada sistema hace una cosa
3. **Desacoplamiento por señales** - Los sistemas se comunican vía signals
4. **Datos sobre código** - Todo configurable, nada hardcodeado
5. **Escalabilidad** - Añadir contenido sin modificar sistemas existentes

## Arquitectura de Sistemas

```
┌─────────────────────────────────────────────────────────────┐
│                     GAME MANAGER                            │
│  (Orquestador principal, controla flujo de juego)           │
└──────────────┬──────────────────────────┬───────────────────┘
               │                          │
       ┌───────▼────────┐        ┌────────▼────────┐
       │  WAVE SYSTEM   │        │  ECONOMY SYSTEM  │
       │  (Oleadas)     │        │  (Moneda/XP)     │
       └───────┬────────┘        └────────┬────────┘
               │                          │
       ┌───────▼────────┐        ┌────────▼────────┐
       │  SPAWN SYSTEM  │        │  SHOP SYSTEM    │
       │  (Enemigos)    │        │  (Tienda)       │
       └───────┬────────┘        └─────────────────┘
               │
       ┌───────▼────────┐
       │  ENTITY SYSTEM │
       │  (Jugador/Enemigos) │
       └───────┬────────┘
               │
       ┌───────▼────────┐
       │  COMBAT SYSTEM │
       │  (Armas/Daño)  │
       └───────┬────────┘
               │
       ┌───────▼────────┐
       │  PROGRESSION   │
       │  (Niveles/Mejoras) │
       └────────────────┘
```

## Flujo del Juego

```
MAIN MENU → CHARACTER SELECT → GAME START
                                    │
                                    ▼
                              WAVE START
                                    │
                                    ▼
                         ┌──────────────────┐
                         │  COMBAT PHASE    │
                         │  (20-30 min)     │
                         │                  │
                         │  - Mover         │
                         │  - Atacar        │
                         │  - Recoger XP    │
                         │  - Subir nivel   │
                         │  - Elegir mejora │
                         └────────┬─────────┘
                                  │
                                  ▼
                           WAVE END
                                  │
                                  ▼
                         ┌──────────────────┐
                         │  REWARD PHASE    │
                         │  - Shop          │
                         │  - Rest          │
                         │  - Upgrade       │
                         └────────┬─────────┘
                                  │
                                  ▼
                           NEXT WAVE
                                  │
                                  ▼
                           GAME OVER
                                  │
                                  ▼
                           STATS SCREEN
```

## Módulos del Sistema

### 1. Core (Núcleo)
- **GameManager**: Controla el estado global del juego
- **EventBus**: Signals globales para comunicación entre sistemas
- **DataBus**: Datos compartidos entre sistemas
- **SaveSystem**: Persistencia de datos

### 2. Player (Jugador)
- **Player**: Nodo principal del jugador
- **PlayerMovement**: Lógica de movimiento
- **PlayerCombat**: Gestión de armas y ataque
- **PlayerStats**: Estadísticas y atributos
- **PlayerAnimations**: Control de animaciones

### 3. Enemies (Enemigos)
- **EnemyBase**: Clase base para todos los enemigos
- **EnemyIA**: Máquina de estados (Idle, Seek, Attack, Recover, Dead)
- **EnemySpawner**: Sistema de generación de enemigos
- **EnemyTypes**: Tipos específicos (Melee, Ranged, Tank, Fast, MiniBoss, Boss)

### 4. Weapons (Armas)
- **WeaponBase**: Clase base para armas
- **WeaponManager**: Gestión de armas equipadas
- **Projectile**: Sistema de proyectiles
- **WeaponTypes**: Tipos específicos de armas

### 5. Items (Objetos)
- **ItemBase**: Clase base para objetos
- **ItemDatabase**: Base de datos de objetos
- **PassiveItem**: Objetos pasivos
- **Consumible**: Objetos consumibles
- **Relic**: Objetos raros

### 6. Waves (Oleadas)
- **WaveManager**: Control de oleadas
- **WaveData**: Datos de oleadas (Resource)
- **WaveConfig**: Configuración de dificultad

### 7. UI (Interfaz)
- **HUD**: Interfaz durante el juego
- **ShopUI**: Interfaz de tienda
- **PauseMenu**: Menú de pausa
- **UpgradeUI**: Selección de mejoras
- **MainMenu**: Menú principal

### 8. Economy (Economía)
- **CurrencyManager**: Moneda y XP
- **LevelSystem**: Sistema de niveles
- **ShopSystem**: Lógica de tienda

### 9. Effects (Efectos)
- **ParticleManager**: Efectos de partículas
- **ScreenEffects**: Efectos de pantalla
- **DamageNumbers**: Números de daño

### 10. Audio (Audio)
- **AudioManager**: Gestión de audio
- **MusicManager**: Música
- **SFXManager**: Efectos de sonido

## Flujo de Datos

### Señales Globales (EventBus)

```gdscript
# GameManager
signal game_started
signal game_paused
signal game_over
signal wave_started(wave_number)
signal wave_completed(wave_number)

# Player
signal player_damaged(amount)
signal player_healed(amount)
signal player_died
signal player_leveled_up(new_level)

# Combat
signal enemy_damaged(enemy, amount)
signal enemy_killed(enemy)
signal weapon_fired(weapon)

# Economy
signal currency_changed(amount)
signal xp_gained(amount)
signal item_purchased(item)
signal item_sold(item)

# UI
signal upgrade_selected(upgrade)
signal shop_opened
signal shop_closed
```

### Recursos de Datos

```gdscript
# WaveData.gd
class_name WaveData
extends Resource

@export var wave_number: int
@export var duration: float
@export var enemy_types: Array[EnemyData]
@export var spawn_rate: float
@export var difficulty_multiplier: float

# EnemyData.gd
class_name EnemyData
extends Resource

@export var enemy_name: String
@export var health: float
@export var damage: float
@export var speed: float
@export var xp_value: int
@export var scene: PackedScene

# WeaponData.gd
class_name WeaponData
extends Resource

@export var weapon_name: String
@export var base_damage: float
@export var attack_speed: float
@export var range: float
@export var projectiles: int
@export var scene: PackedScene

# ItemData.gd
class_name ItemData
extends Resource

@export var item_name: String
@export var description: String
@export var cost: int
@export var rarity: Rarity
@export var effects: Array[StatModifier]

# StatModifier.gd
class_name StatModifier
extends Resource

@export var stat: String
@export var value: float
@export var modifier_type: ModifierType

enum ModifierType { FLAT, PERCENTAGE }
enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }
```

## Patrones de Diseño

### 1. Component Pattern
Cada entidad se compone de nodos especializados:
```
Player
├── PlayerMovement
├── PlayerCombat
├── PlayerStats
├── HurtboxComponent
├── HitboxComponent
└── AnimationPlayer
```

### 2. Observer Pattern (Signals)
Los sistemas se comunican sin conocerse:
```gdscript
# Enemy emite señal
enemy_killed.emit(enemy)

# EconomySystem escucha
func _on_enemy_killed(enemy: Enemy):
    currency_manager.add_xp(enemy.xp_value)
```

### 3. State Machine
IA de enemigos y estados del juego:
```gdscript
enum State { IDLE, SEEK, ATTACK, RECOVER, DEAD }
var current_state: State = State.IDLE
```

### 4. Object Pooling
Reutilizar instancias para rendimiento:
```gdscript
var projectile_pool: Array[Projectile]

func get_projectile() -> Projectile:
    for p in projectile_pool:
        if not p.active:
            return p
    return create_new_projectile()
```

## Optimización

### Object Pooling
- Proyectiles
- Enemigos
- Efectos de partículas
- Números de daño

### Culling
- Off-screen enemies se desactivan
- Proyectiles fuera de pantalla se reciclan

### Física
- Usar áreas en lugar de cuerpos cuando sea posible
- Simplificar colisiones para muchos enemigos

## Escalabilidad

### Para añadir un enemigo nuevo:
1. Crear `EnemyData` resource
2. Crear escena del enemigo
3. Añadir a la escena del enemigo
4. Registrar en la base de datos de enemigos

### Para añadir un arma nueva:
1. Crear `WeaponData` resource
2. Crear escena del arma
3. Implementar lógica de ataque
4. Registrar en la base de datos de armas

### Para añadir un objeto nuevo:
1. Crear `ItemData` resource
2. Implementar efecto
3. Añadir a la base de datos de objetos

## Dependencias

```
Core ← Player
Core ← Enemies
Core ← Waves
Player ← Weapons
Player ← Items
Enemies ← Waves
Weapons ← Combat
Items ← Economy
UI ← Core
UI ← Player
UI ← Economy
```

## Convenciones

### Nomenclatura
- Scripts: `snake_case.gd`
- Escenas: `PascalCase.tscn`
- Recursos: `PascalCase.tres`
- Carpetas: `snake_case/`
- Clases: `PascalCase`
- Variables: `snake_case`
- Funciones: `snake_case`
- Señales: `snake_case`
- Enums: `PascalCase`

### Estructura de Scripts
```gdscript
class_name ClassName
extends BaseClass

# Señales
signal my_signal

# Enums
enum State { IDLE, ACTIVE }

# Variables exported
@export var property: Type

# Variables locales
var _private_var: Type

# Funciones built-in
func _ready():
    pass

# Funciones públicas
func public_function():
    pass

# Funciones privadas
func _private_function():
    pass

# Funciones de señal
func _on_signal_name():
    pass
```
