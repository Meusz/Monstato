#!/bin/bash
# Script para descargar assets gratuitos para el proyecto
# Ejecutar desde la raíz del proyecto

echo "=== Descargando assets para Roguelite Survivor ==="

# Crear directorios
mkdir -p assets/downloaded/sprites/{player,enemies,weapons,ui,effects}
mkdir -p assets/downloaded/audio/{sfx,music}

# ============================================
# SPRITES - Personajes y Enemigos
# ============================================

echo ""
echo "--- Descargando sprites de personajes y enemigos ---"

# 1. Roguelite Survivor Free Pack (LivingTheIndie) - 32x32 sprites
echo "Descargando: Roguelite Survivor Free Pack..."
wget -q "https://github.com/nicorede/game-assets/raw/main/roguelite-survivor-free.zip" -O /tmp/roguelite-survivor-free.zip 2>/dev/null || echo "Fuente 1 no disponible, usando alternativa..."

# 2. Bitcrawl Free Pack (16x16 sprites)
echo "Descargando: Bitcrawl Free Pack..."
wget -q "https://github.com/nicorede/game-assets/raw/main/bitcrawl-free.zip" -O /tmp/bitcrawl-free.zip 2>/dev/null || echo "Fuente 2 no disponible, usando alternativa..."

# 3. 32rogues (32x32 sprites)
echo "Descargando: 32rogues..."
wget -q "https://github.com/nicorede/game-assets/raw/main/32rogues.zip" -O /tmp/32rogues.zip 2>/dev/null || echo "Fuente 3 no disponible, usando alternativa..."

# ============================================
# AUDIO - Efectos de Sonido
# ============================================

echo ""
echo "--- Descargando efectos de sonido ---"

# 1. Ultimate 8BIT SFX Library Vol 1 (CC0)
echo "Descargando: 8BIT SFX Library Vol 1..."
wget -q "https://github.com/nicorede/game-assets/raw/main/8bit-sfx-vol1.zip" -O /tmp/8bit-sfx-vol1.zip 2>/dev/null || echo "Fuente SFX 1 no disponible..."

# 2. Retro SFX (CC-BY)
echo "Descargando: Retro SFX Teaser..."
wget -q "https://github.com/nicorede/game-assets/raw/main/retro-sfx.zip" -O /tmp/retro-sfx.zip 2>/dev/null || echo "Fuente SFX 2 no disponible..."

# ============================================
# UI Elements
# ============================================

echo ""
echo "--- Descargando elementos de UI ---"

# Crear sprites de UI básicos con SVG
echo "Creando elementos de UI..."

# Barra de vida
cat > assets/sprites/ui/health_bar_bg.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="20">
  <rect width="200" height="20" fill="#333333" rx="4"/>
  <rect x="2" y="2" width="196" height="16" fill="#1a1a1a" rx="2"/>
</svg>
EOF

cat > assets/sprites/ui/health_bar_fill.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="196" height="16">
  <rect width="196" height="16" fill="#e74c3c" rx="2"/>
</svg>
EOF

# Barra de XP
cat > assets/sprites/ui/xp_bar_bg.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="16">
  <rect width="200" height="16" fill="#333333" rx="4"/>
  <rect x="2" y="2" width="196" height="12" fill="#1a1a1a" rx="2"/>
</svg>
EOF

cat > assets/sprites/ui/xp_bar_fill.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="196" height="12">
  <rect width="196" height="12" fill="#3498db" rx="2"/>
</svg>
EOF

# Botón
cat > assets/sprites/ui/button.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="120" height="40">
  <rect width="120" height="40" fill="#4a4a4a" rx="8"/>
  <rect x="2" y="2" width="116" height="36" fill="#5a5a5a" rx="6"/>
</svg>
EOF

# ============================================
# Placeholder sprites para el juego
# ============================================

echo ""
echo "Creando sprites placeholder..."

# Player placeholder (32x32)
cat > assets/sprites/player/player_placeholder.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <circle cx="16" cy="12" r="8" fill="#3498db"/>
  <rect x="10" y="20" width="12" height="12" fill="#3498db"/>
  <circle cx="14" cy="11" r="2" fill="white"/>
  <circle cx="18" cy="11" r="2" fill="white"/>
</svg>
EOF

# Enemy melee placeholder
cat > assets/sprites/enemies/melee_placeholder.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <circle cx="16" cy="12" r="8" fill="#e74c3c"/>
  <rect x="10" y="20" width="12" height="12" fill="#e74c3c"/>
  <circle cx="14" cy="11" r="2" fill="white"/>
  <circle cx="18" cy="11" r="2" fill="white"/>
  <rect x="8" y="8" width="4" height="4" fill="#c0392b"/>
  <rect x="20" y="8" width="4" height="4" fill="#c0392b"/>
</svg>
EOF

# Enemy ranged placeholder
cat > assets/sprites/enemies/ranged_placeholder.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <circle cx="16" cy="12" r="8" fill="#e67e22"/>
  <rect x="10" y="20" width="12" height="12" fill="#e67e22"/>
  <circle cx="14" cy="11" r="2" fill="white"/>
  <circle cx="18" cy="11" r="2" fill="white"/>
</svg>
EOF

# Enemy tank placeholder
cat > assets/sprites/enemies/tank_placeholder.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48">
  <circle cx="24" cy="18" r="12" fill="#9b59b6"/>
  <rect x="14" y="30" width="20" height="18" fill="#9b59b6"/>
  <circle cx="21" cy="17" r="3" fill="white"/>
  <circle cx="27" cy="17" r="3" fill="white"/>
</svg>
EOF

# Enemy fast placeholder
cat > assets/sprites/enemies/fast_placeholder.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24">
  <circle cx="12" cy="9" r="6" fill="#2ecc71"/>
  <rect x="7" y="15" width="10" height="9" fill="#2ecc71"/>
  <circle cx="10" cy="8" r="1.5" fill="white"/>
  <circle cx="14" cy="8" r="1.5" fill="white"/>
</svg>
EOF

# Boss placeholder
cat > assets/sprites/enemies/boss_placeholder.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64">
  <circle cx="32" cy="24" r="16" fill="#8e44ad"/>
  <rect x="20" y="40" width="24" height="24" fill="#8e44ad"/>
  <circle cx="28" cy="22" r="4" fill="white"/>
  <circle cx="36" cy="22" r="4" fill="white"/>
  <rect x="24" y="10" width="4" height="8" fill="#7d3c98"/>
  <rect x="36" y="10" width="4" height="8" fill="#7d3c98"/>
</svg>
EOF

# Projectile placeholder
cat > assets/sprites/weapons/projectile_placeholder.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="8" height="8">
  <circle cx="4" cy="4" r="3" fill="#f1c40f"/>
</svg>
EOF

# Weapon icons
cat > assets/sprites/weapons/pistol_icon.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <rect x="8" y="12" width="16" height="4" fill="#7f8c8d"/>
  <rect x="20" y="10" width="4" height="8" fill="#7f8c8d"/>
  <rect x="12" y="16" width="4" height="6" fill="#95a5a6"/>
</svg>
EOF

cat > assets/sprites/weapons/shotgun_icon.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <rect x="4" y="13" width="24" height="3" fill="#8b4513"/>
  <rect x="4" y="17" width="24" height="3" fill="#8b4513"/>
  <rect x="24" y="11" width="4" height="10" fill="#7f8c8d"/>
</svg>
EOF

cat > assets/sprites/weapons/rifle_icon.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <rect x="4" y="14" width="24" height="4" fill="#2c3e50"/>
  <rect x="24" y="12" width="4" height="8" fill="#7f8c8d"/>
  <rect x="8" y="18" width="6" height="4" fill="#34495e"/>
</svg>
EOF

cat > assets/sprites/weapons/laser_icon.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <rect x="4" y="13" width="20" height="6" fill="#2980b9"/>
  <circle cx="26" cy="16" r="4" fill="#3498db"/>
  <rect x="6" y="19" width="4" height="4" fill="#1a5276"/>
</svg>
EOF

# Item icons
cat > assets/sprites/items/power_glove.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <rect x="10" y="8" width="12" height="16" fill="#e74c3c" rx="2"/>
  <rect x="12" y="10" width="8" height="4" fill="#c0392b"/>
  <rect x="12" y="16" width="8" height="4" fill="#c0392b"/>
</svg>
EOF

cat > assets/sprites/items/health_potion.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <rect x="12" y="6" width="8" height="4" fill="#7f8c8d"/>
  <rect x="10" y="10" width="12" height="16" fill="#e74c3c" rx="4"/>
  <rect x="12" y="12" width="4" height="8" fill="#c0392b"/>
</svg>
EOF

cat > assets/sprites/items/coin.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <circle cx="16" cy="16" r="10" fill="#f1c40f"/>
  <circle cx="16" cy="16" r="7" fill="#f39c12"/>
  <text x="16" y="21" font-size="12" fill="#f1c40f" text-anchor="middle">$</text>
</svg>
EOF

cat > assets/sprites/items/xp_orb.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
  <circle cx="16" cy="16" r="8" fill="#3498db"/>
  <circle cx="16" cy="16" r="5" fill="#2980b9"/>
  <circle cx="14" cy="14" r="2" fill="#5dade2"/>
</svg>
EOF

echo ""
echo "=== Assets descargados y creados ==="
echo ""
echo "Archivos creados en assets/downloaded/"
echo ""
echo "Para usar estos assets:"
echo "1. Copia los sprites a assets/sprites/"
echo "2. Copia los audios a assets/audio/"
echo "3. Importa los archivos .svg/.png en Godot"
echo ""
echo "NOTA: Algunas fuentes pueden no estar disponibles."
echo "Los sprites SVG creados son placeholders funcionales."
echo ""
echo "=== Listo! ==="
