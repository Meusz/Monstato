# Monstato

Survivor roguelite inspired by Brotato,built with Godot 4.7 (GDScript).

**Objective:** Survive as many waves as possible. Buy companions, weapons and items in the shop between waves. Upgrade your loadout. Dies once — you can revive once with an ad.

## Features

- **Monster companions** — buy monsters from the shop, they orbit the player and auto-attack.
- **Elemental system** — Grass > Water > Fire > Grass rock-paper-scissors.
- **Phase upgrades** — buy 2 identical monsters → they combine into a stronger Phase 2 (up to Phase 4).
- **4 playable trainers** — Warrior, Ranger, Tank, Mage. Each has unique base stats and an active ability (press `E`).
- **9 weapons** — Pistol, Shotgun, Rifle, Laser, SMG, Rocket, Sniper, Dual Pistols, Scatter Gun, Plasma Cannon (all purchasable in shop).
- **10 monsters** — with elemental effects (burn, poison, freeze, bleed, shield, lifesteal).
- **22 items** — passives, relics and consumables with stat modifiers.
- **Wave-based combat** — escalating enemy counts, spawn rates and HP scaling.
- **Bosses** — appear starting from wave 10.
- **Touch controls** — virtual joystick + dash/ability buttons for mobile.
- **Shoppabilities** — buy companions, weapons, items. Upgrade slot capacity.
- **Revive mechanic** — watch an ad to revive once per run.

## How to play

1. **Select a trainer** (Warrior/Ranger/Tank/Mage).
2. **Choose a starting monster** for the arena.
3. **Survive waves** of 30 seconds each. Monsters spawn at indicated locations on the field.
4. **Buy in the shop** — companions, weapons and items to strengthen your build.
5. **Combine monsters** — buy a monster you already have to evolve it to the next phase (higher stats).
6. **Press E** to use your trainer's active ability.
7. **Press Space or DASH** to dodge (dash forward).
8. **Die** → click "Revive with Ad" to continue once per run.

## Tech stack

| Layer | Tool |
|-------|------|
| Engine | Godot 4.7.1 |
| Language | GDScript (classes, resources, signals) |
| State management | DataBus (centralized store) |
| Communication | EventBus (global signals) |
| Asset generation | Runtime pixel art (SpriteGenerator) |

## Project structure

```
core/          — GameManager, EventBus, DataBus, SaveSystem, AudioManager
player/        — Movement, combat, dash, trainer ability, stats
companions/    — Monster data, database, node (orbit + auto-attack)
enemies/       — Enemy types (melee/fast/ranged/tank/mini_boss/boss), spawner, IА.
weapons/       — Projectiles, weapon database, weapon manager
weapons/       — Projectiles, weapon database, weapon manager
items/         — Item data, passive items, consumables, relics
economy/       — Currency manager, coin pickup, shop system
waves/         — Wave config, wave manager, spawner config.
Maps/a          — Arena map (1200x900, walls, grid)..
ui/            — Main menu, character select, companion select, HUD, shop, game over, pause, upgrades.
shared/        — Health component, hitbox, hurtbox, knockback, particles.
assets/        — SVG sprites (player, enemies, items).
```

## How to run

1. **Install** Godot 4.7.1 (Linux, Windows, macOS).
   [godotengine.org](https://godotengine.org)
2. Open the project at:
   `File → Open Project → /path/to/Monstato/`
3. Click **▶ Play** or press `F5`.

## Building for mobile (Android)

1. Install **JDK 17** and **Android SDK** (Godot → Tools → Android → Install).
2. Export via:
   `Project → Export → Add Export → Android`
3. Choose a keystore and sign the APK.

## Roadmap

- [ ] More trainers (20 total) with unique abilities
- [ ] Multiple arenas with environmental hazards (lava, ice, etc.)
- [ ] More weapons and items (100+ items, 50+ enemies, 200+ items total)
- [ ] Leaderboards / remote saves
- [ ] Better audio integration
- [ ] Polished UI transitions

## Contributing

Feel free to open issues and pull requests. Please:
- Use explicit type annotations (`var x: Type = ...`) — Godot 4.7 drops the `:=` inference.
- Follow the existing code style (4-space indent, snake_case).
- Add meaningful commit messages.
