# 2D Onmyoji-Style Game Plan

## Goal

Build a small 2D top-down action RPG prototype with an onmyoji-inspired theme: a player character explores a compact arena, defeats yokai-like enemies, casts simple talisman/spell abilities, and opens a minimal RPG UI for status and progression.

To avoid depending on another game's IP, treat "Onmyoji" as a theme direction: Japanese occult fantasy, shikigami, talismans, spirits, shrine/courtyard environments, and ritual magic.

## First Playable Scope

1. Create a playable top-down combat scene.
2. Add one controllable protagonist using the current swordsman pack as a placeholder.
3. Add three enemy families using existing slime, plant, and orc packs.
4. Add one spell or summon ability using the animated magic book pack as a placeholder magical object/effect.
5. Add minimal HUD: HP, skill cooldown, enemy wave count, win/lose screen.
6. Add one arena map with placeholder tiles or simple Godot shapes until themed map assets are added.

## Existing Resources

Available packs under `resources/`:

- `craftpix-net-180537-free-swordsman-1-3-level-pixel-top-down-sprite-character`: 728 PNG, 192 Aseprite, 48 PSD. Good placeholder protagonist with idle, walk, run, attack, hurt, death, and shadow variants.
- `craftpix-net-255216-free-basic-pixel-art-ui-for-rpg`: 40 PNG, 26 PSD. Useful for main menu, buttons, action panel, character panel, inventory, settings, shop, numbers, win/lose UI, icons, and RPG panels.
- `craftpix-net-284465-free-predator-plant-mobs-pixel-art-pack`: 378 PNG, 144 Aseprite, 36 PSD. Good enemy family with idle, walk/run, attack, hurt, and death animations.
- `craftpix-net-363992-free-top-down-orc-game-character-pixel-art`: 672 PNG, 192 Aseprite, 48 PSD. Good enemy family or elite/boss placeholder.
- `craftpix-net-788364-free-slime-mobs-pixel-art-top-down-sprite-pack`: 318 PNG, 144 Aseprite, 36 PSD. Good early enemy family.
- `craftpix-net-809047-free-animated-magic-book-pixel-art-asset-pack`: 152 PNG, 18 Aseprite, 24 PSD. Useful as a spellbook, summon catalyst, loot object, or magic UI icon placeholder.

These resources are enough for a combat prototype and a first playable loop.

## Resource Gaps

Needed before the project feels like a real onmyoji-style game:

- Themed protagonist: onmyoji robe, fan, talisman, paper charm, or ritual staff animations.
- Shikigami/yokai allies: at least one summonable spirit with idle, move, attack, hurt, and death/vanish animations.
- Japanese occult enemies: oni, fox spirit, paper doll, ghost, tengu, lantern yokai, or mask spirit. Current slime/plant/orc enemies are usable mechanically but not thematically strong.
- Environment tileset: shrine courtyard, torii gate, stone path, tatami room, forest at night, lanterns, water, walls, props, and collision-ready tiles.
- Spell VFX: talisman projectile, summoning circle, yin-yang burst, seal impact, healing/ward effect, and enemy hit effects.
- Audio: footsteps, hit sounds, spell cast, UI click, enemy death, ambient loop, combat music.
- UI theme pass: current RPG UI works for layout, but needs onmyoji-style frames, paper textures, talisman icons, and better skill icons.
- Fonts: readable Chinese/Japanese-style font with a license suitable for the project.
- Portraits/dialogue assets: optional for later, but needed if the game has story, gacha-like character screens, or visual-novel-style interactions.

## Development Phases

### Phase 1: Project Foundation

- Create `scenes/`, `scripts/`, `assets/`, and `ui/` folders.
- Create `main.tscn`, `player.tscn`, `enemy.tscn`, `hud.tscn`, and a small test arena.
- Configure the main scene in `project.godot` using the Godot editor if possible.
- Add input actions: move up/down/left/right, attack, skill_1, skill_2, interact, pause.

### Phase 2: Combat Prototype

- Implement top-down player movement with `CharacterBody2D`.
- Wire swordsman idle/move/attack/hurt/death placeholder animations.
- Implement enemy AI: idle, chase, attack, take damage, die.
- Add enemy spawner and one wave clear condition.
- Add simple HP/damage/cooldown data resources.

### Phase 3: Onmyoji Mechanics

- Add talisman projectile or short-range seal attack.
- Add one summon/spell placeholder using the magic book assets.
- Add enemy status effect hooks: slow, bind, burn, or ward break.
- Add a simple yin-yang energy meter that fills during combat and spends on a skill.

### Phase 4: UI and Loop

- Build HUD using the RPG UI pack.
- Add pause menu and win/lose panel.
- Add a result screen showing defeated enemies and time survived.
- Add a title/menu scene only after the core loop is playable.

### Phase 5: Theming Pass

- Replace placeholder swordsman/orc/slime choices with onmyoji, shikigami, and yokai assets as they become available.
- Replace placeholder arena with shrine/courtyard tiles.
- Add spell VFX and audio.
- Normalize asset naming into `assets/characters/`, `assets/enemies/`, `assets/ui/`, `assets/vfx/`, and `assets/audio/`.

## Recommended Next Step

Start with Phase 1 and Phase 2 using the existing swordsman, slime, plant, orc, magic book, and RPG UI assets. In parallel, look for or create the missing themed assets: onmyoji protagonist, shrine tileset, shikigami/yokai, talisman VFX, and audio.

Before coding, clean or ignore generated macOS archive artifacts such as `__MACOSX`, `.DS_Store`, and `._*` files if they are not intentionally needed.
