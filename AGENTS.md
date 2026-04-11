# Repository Guidelines

## Project Structure & Module Organization

This is a Godot 4.6 project named `2d_test_game`. The root contains `project.godot`, `icon.svg`, import metadata, and editor config files. Runtime project content should live in Godot-standard folders such as `scenes/`, `scripts/`, `assets/`, or `ui/` when added.

Current large third-party asset packs are under `resources/`, including Craftpix PNG, PSD, Aseprite, Tiled, ZIP, and license files. Keep original downloaded packs and licenses together. The `addons/godot_mcp/` directory contains the Godot MCP plugin; avoid mixing game-specific code into this addon unless intentionally modifying the plugin.

## Build, Test, and Development Commands

Open the project in the editor:

```powershell
godot --path .
```

Run the project from the command line after a main scene is configured:

```powershell
godot --path .
```

Run a headless import or basic project load check:

```powershell
godot --headless --path . --quit
```

Export only after export presets are added:

```powershell
godot --headless --path . --export-release "Preset Name" build/game.exe
```

## Coding Style & Naming Conventions

Use UTF-8 for all files, matching `.editorconfig`. For GDScript, follow Godot conventions: tabs for indentation, `snake_case` for files, variables, functions, and signals, and `PascalCase` for class names and scene/node types. Name scenes after their primary responsibility, for example `player.tscn`, `main_menu.tscn`, or `enemy_spawner.tscn`.

Keep generated `.import` files with their source assets. Do not hand-edit `project.godot` or `.import` files unless the change is simple and reviewable; prefer the Godot editor for settings that affect resources.

## Testing Guidelines

No test framework or test directory is currently present. For new gameplay or plugin behavior, add focused tests when introducing a Godot test runner such as GUT, and place them under `tests/` with names like `test_player_movement.gd`. Until then, verify changes by running `godot --headless --path . --quit` and manually checking affected scenes in the editor.

## Commit & Pull Request Guidelines

This checkout does not include local git history, so no existing commit convention can be inferred. Use short, imperative commit subjects such as `Add player movement scene` or `Import slime sprite pack`. Pull requests should include a concise change summary, manual verification steps, linked issues when applicable, and screenshots or short clips for visible gameplay, scene, or UI changes.

## Security & Configuration Tips

Do not commit machine-specific editor caches from `.godot/`. Preserve third-party asset license files in `resources/`, and document any new asset source when adding packs.

## Agent-Specific Instructions

At the start of each session, read and follow `PROJECT_MEMORY.md` in the repository root. Before starting any task, check Git status and commit any pre-existing local changes. Plan every task first and write the plan under `doc/` before implementation.
