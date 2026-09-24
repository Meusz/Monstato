# Lista de Escenas

## Escenas Principales

### 1. Escenas de Juego
| Escena | Ruta | Descripción |
|--------|------|-------------|
| Main Scene | `res://core/main.tscn` | Escena principal que carga todo |
| Game World | `res://maps/arena/arena.tscn` | Mapa del juego |
| Player | `res://player/player.tscn` | Personaje jugable |
| HUD | `res://ui/hud/hud.tscn` | Interfaz durante juego |
| Main Menu | `res://ui/main_menu/main_menu.tscn` | Menú principal |

### 2. Escenas de Enemigos
| Escena | Ruta | Descripción |
|--------|------|-------------|
| Enemy Base | `res://enemies/enemy_base.tscn` | Escena base para todos |
| Melee Enemy | `res://enemies/types/melee/melee_enemy.tscn` | Enemigo cuerpo a cuerpo |
| Ranged Enemy | `res://enemies/types/ranged/ranged_enemy.tscn` | Enemigo a distancia |
| Tank Enemy | `res://enemies/types/tank/tank_enemy.tscn` | Enemigo tanque |
| Fast Enemy | `res://enemies/types/fast/fast_enemy.tscn` | Enemigo rápido |
| Mini Boss | `res://enemies/types/mini_boss/mini_boss.tscn` | Mini jefe |
| Boss | `res://enemies/types/boss/boss.tscn` | Jefe final |

### 3. Escenas de Armas
| Escena | Ruta | Descripción |
|--------|------|-------------|
| Weapon Base | `res://weapons/weapon_base.tscn` | Escena base para armas |
| Projectile | `res://weapons/projectile/projectile.tscn` | Proyectil genérico |
| Pistol | `res://weapons/types/pistol/pistol.tscn` | Pistola |
| Shotgun | `res://weapons/types/shotgun/shotgun.tscn` | Escopeta |
| Rifle | `res://weapons/types/rifle/rifle.tscn` | Rifle |
| Laser | `res://weapons/types/laser/laser.tscn` | Láser |

### 4. Escenas de Objetos
| Escena | Ruta | Descripción |
|--------|------|-------------|
| Passive Item | `res://items/passive/passive_item.tscn` | Objeto pasivo |
| Consumable | `res://items/consumable/consumable_item.tscn` | Consumible |
| Relic | `res://items/relic/relic_item.tscn` | Reliquia |

### 5. Escenas de UI
| Escena | Ruta | Descripción |
|--------|------|-------------|
| HUD | `res://ui/hud/hud.tscn` | Interfaz principal |
| Health Bar | `res://ui/hud/health_bar.tscn` | Barra de vida |
| XP Bar | `res://ui/hud/xp_bar.tscn` | Barra de experiencia |
| Wave Timer | `res://ui/hud/wave_timer.tscn` | Timer de oleada |
| Currency Display | `res://ui/hud/currency_display.tscn` | Muestra de moneda |
| Weapon Slots | `res://ui/hud/weapon_slots.tscn` | Slots de armas |
| Shop UI | `res://ui/shop/shop_ui.tscn` | Interfaz de tienda |
| Shop Item Slot | `res://ui/shop/shop_item_slot.tscn` | Slot de objeto en tienda |
| Upgrade UI | `res://ui/upgrade/upgrade_ui.tscn` | Selección de mejoras |
| Upgrade Card | `res://ui/upgrade/upgrade_card.tscn` | Tarjeta de mejora |
| Pause Menu | `res://ui/pause/pause_menu.tscn` | Menú de pausa |
| Main Menu | `res://ui/main_menu/main_menu.tscn` | Menú principal |

### 6. Escenas de Efectos
| Escena | Ruta | Descripción |
|--------|------|-------------|
| Damage Number | `res://effects/damage_numbers/damage_number.tscn` | Número de daño |
| Hit Effect | `res://effects/particles/hit_effect.tscn` | Efecto de impacto |
| Death Effect | `res://effects/particles/death_effect.tscn` | Efecto de muerte |
| Level Up Effect | `res://effects/particles/level_up_effect.tscn` | Efecto de subir nivel |

## Estructura de Escenas

### Player Scene
```
Player (CharacterBody2D)
├── CollisionShape2D
├── Sprite2D
├── AnimationPlayer
├── PlayerMovement (Node)
├── PlayerCombat (Node)
├── PlayerStats (Node)
├── PlayerInput (Node)
├── DashAbility (Node)
├── HurtboxComponent (Area2D)
│   └── CollisionShape2D
├── HitboxComponent (Area2D)
│   └── CollisionShape2D
└── WeaponPivot (Node2D)
    └── [Weapon instances]
```

### Enemy Base Scene
```
EnemyBase (CharacterBody2D)
├── CollisionShape2D
├── Sprite2D
├── AnimationPlayer
├── EnemyIA (Node)
├── EnemyMovement (Node)
├── EnemyAttack (Node)
├── EnemyHealth (Node)
├── HurtboxComponent (Area2D)
│   └── CollisionShape2D
├── HitboxComponent (Area2D)
│   └── CollisionShape2D
└── DetectionArea (Area2D)
    └── CollisionShape2D
```

### Weapon Base Scene
```
WeaponBase (Node2D)
├── Sprite2D
├── AnimationPlayer
├── AttackCooldown (Timer)
├── ProjectileSpawnPoint (Node2D)
└── WeaponStats (Node)
```

### HUD Scene
```
HUD (CanvasLayer)
├── MarginContainer
│   ├── TopBar
│   │   ├── HealthBar
│   │   ├── XPBar
│   │   ├── WaveTimer
│   │   └── CurrencyDisplay
│   ├── BottomBar
│   │   ├── WeaponSlots
│   │   └── ItemSlots
│   └── SidePanel
│       ├── MiniMap
│       └── EnemyCount
└── UpgradePopup (hidden by default)
```

### Shop UI Scene
```
ShopUI (Control)
├── Background
├── ShopContainer
│   ├── ItemGrid
│   │   ├── ShopItemSlot
│   │   ├── ShopItemSlot
│   │   ├── ShopItemSlot
│   │   └── ShopItemSlot
│   ├── RefreshButton
│   └── CloseButton
├── PlayerInventory
│   ├── CurrencyDisplay
│   └── OwnedItems
└── ItemDescription
```

### Upgrade UI Scene
```
UpgradeUI (Control)
├── Background
├── UpgradeContainer
│   ├── UpgradeCard
│   ├── UpgradeCard
│   └── UpgradeCard
└── Timer (optional)
```

### Main Menu Scene
```
MainMenu (Control)
├── Background
├── TitleLabel
├── ButtonContainer
│   ├── PlayButton
│   ├── SettingsButton
│   ├── CreditsButton
│   └── QuitButton
└── VersionLabel
```

### Pause Menu Scene
```
PauseMenu (Control)
├── Background (semi-transparent)
├── PauseContainer
│   ├── ResumeButton
│   ├── SettingsButton
│   ├── MainMenuButton
│   └── QuitButton
└── PauseLabel
```

## Configuración de Escenas

### Collision Layers
```
Layer 1: Player
Layer 2: Enemies
Layer 3: Player Projectiles
Layer 4: Enemy Projectiles
Layer 5: Items
Layer 6: Walls
Layer 7: Pickups (XP, Coins)
Layer 8: UI
```

### Physics Bodies
```
CharacterBody2D:
- Player
- Enemies

Area2D:
- Hitboxes
- Hurtboxes
- Detection Areas
- Pickups
- Projectiles

StaticBody2D:
- Walls
- Obstacles
```

### TileMaps
```
Arena:
- Ground Layer (Layer 1)
- Wall Layer (Layer 2)
- Decoration Layer (Layer 3)
- Navigation Layer (for pathfinding)
```
