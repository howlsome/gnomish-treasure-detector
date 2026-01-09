# Gnomish Treasure Detector

Gnomish Treasure Detector is a lightweight World of Warcraft addon that alerts you to nearby treasures and rare creatures using a raid warning, sound, and a chat message.

It is compatible with **World of Warcraft: Midnight** (interface `120000`).

---

## Features

- **Treasure & rare alerts**
  - Raid warning message with the vignette’s icon.
  - Optional sound alert (configurable).
  - Chat message showing what was spotted.

- **Vignette filtering**
  - Ignores “spammy” vignettes such as:
    - Garrison Cache / Full Garrison Cache.
    - Dragonflight hub NPCs like Rostrum of Transformation, Renown Quartermaster, Bronze Timekeeper.
    - The War Within Hallowfall keyflames.
    - Delves companions such as Brann Bronzebeard.
  - Vignettes are managed via a dedicated config file (`vignettes.lua`) grouped by expansion/feature.

- **In-game options**
  - Toggle **sound alerts** on/off.
  - Enable/disable **individual vignettes** in a scrollable, grouped list.
  - Slash command: `/gtd` to open the options panel.

- **Simple, configurable data**
  - All vignette defaults live in `vignettes.lua`.
  - Advanced users can add or adjust entries without touching the core logic.

---

## Usage

### Getting alerts

Once the addon is installed and enabled:

- When you get close to a tracked vignette (rare/treasure/etc.), you’ll see:
  - A **raid warning** in the center of the screen.
  - An optional **sound effect**.
  - A **chat message** like:

    > [icon] Rare Name spotted!

The addon remembers which vignette IDs it has announced so you don’t get spammed repeatedly for the same one.

### Options

Open the options in one of two ways:

- Interface → AddOns → **Gnomish Treasure Detector**
- Or type:

  ```chat
  /gtd
  ```

In the options panel you can:

- **Enable sound alerts**:
  - When checked, a sound plays when a vignette is first spotted.
  - When unchecked, you still get the visual/chat alerts but no sound.

- **Configure individual vignettes**:
  - Vignettes are grouped by expansion/feature (e.g. Garrison, Dragonflight NPCs, The War Within keyflames, Midnight utility).
  - Each entry is a checkbox:
    - Checked: this vignette **will** trigger alerts.
    - Unchecked: this vignette is **suppressed**.

Changes take effect immediately; no reload is required.

---

## Advanced configuration

If you’re comfortable editing Lua files, you can customize the vignette list directly:

- Open `vignettes.lua` in a text editor.
- Vignettes are organized into groups:

  ```lua
  GTD_VIGNETTE_GROUPS = {
      WOD_GARRISON = {
          name = "Warlords of Draenor - Garrison",
          entries = {
              ["Garrison Cache"] = {
                  defaultEnabled = false,
                  note = "Garrison Cache",
              },
              ["Full Garrison Cache"] = {
                  defaultEnabled = false,
                  note = "Full Garrison Cache",
              },
          },
      },

      -- ...other groups...
  }
  ```

- To **add** a new vignette, add an entry under the appropriate group:

  ```lua
  ["Some Midnight Rare"] = {
      defaultEnabled = true,
      note = "Example Midnight rare",
  },
  ```

- To **change the default behavior** of an existing vignette, update `defaultEnabled` to `true` or `false`.

User changes made in-game (via the options panel) are stored in the SavedVariables file and override these defaults.

---

## Compatibility

- **Retail:** World of Warcraft: Midnight (interface `120000`).
- **Client type:** Retail only. Classic/Season variants are not officially supported.

If Blizzard bumps the interface number (e.g. `120001`), you can update the TOC:

```text
## Interface: 120001
```

No code changes should be required unless the underlying vignette APIs change.

---

## Installation

1. Download or clone the repository.
2. Place the folder in your WoW `AddOns` directory, e.g.:

   - Windows: `World of Warcraft/_retail_/Interface/AddOns/`
   - macOS: `World of Warcraft/_retail_/Interface/AddOns/`

3. Ensure the addon is enabled in the in-game AddOns list.
4. Log in and optionally run:

   ```chat
   /console scriptErrors 1
   ```

   if you want Lua errors to pop up for debugging.

---

## Contributing

Suggestions, bug reports, and pull requests are welcome.

Useful contributions include:

- Adding/adjusting vignette entries in `vignettes.lua` for new Midnight content.
- Improving default on/off decisions for noisy vignettes.
- Tweaks to the options UI or behavior that keep the addon simple and lightweight.

---
