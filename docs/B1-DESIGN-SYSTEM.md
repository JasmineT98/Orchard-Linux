# B1 design system

The application names are intentionally simple: **Files, Settings, App Store, Text Editor, Calculator, Terminal**.

The Orchard name belongs to the operating system and internal compatibility layer, not app names.

## Core language

- Orange accent: `#ff7a00`
- Light background: `#f5f5f7`
- Dark background: `#1c1c1e`
- Rounded cards: 14 px
- Rounded controls: 8–10 px
- Compact top bar: 30 px
- Floating dock: 58 px
- Inter system font

## Compatibility strategy

1. Built-in GTK4 apps load the shared system CSS directly.
2. GTK3 apps receive the Orchard compatibility theme.
3. Qt 5/6 apps use Kvantum/Qt configuration as a compatibility layer.
4. Flatpaks receive desktop color-scheme and native file-dialog integration through XDG portals when supported.
5. The compositor supplies consistent window placement, shadows/decorations and workspace behavior.

B1 does not patch third-party application binaries. Apps with custom-rendered UIs retain their own interior design.
