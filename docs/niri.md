# niri Setup

## Config location

`~/.config/niri/config.kdl`

Config is auto-reloaded on save — no restart needed.

## German keyboard layout

niri uses XKB, not the console keymap. Set explicitly in config:

```kdl
input {
    keyboard {
        xkb {
            layout "de"
            variant "nodeadkeys"
        }
    }
}
```

## Keybinding adjustments for German layout

Several default bindings use keys that require Shift on a German keyboard,
making them impossible to press with Mod+Shift. Replacements used:

| Default | Replacement | Action |
|---------|-------------|--------|
| `Mod+Shift+Slash` | `Mod+Shift+Period` | Show hotkey overlay |
| `Mod+BracketLeft` | `Mod+Shift+8` | Consume/expel window left |
| `Mod+BracketRight` | `Mod+Shift+9` | Consume/expel window right |

## Autostart

```kdl
spawn-at-startup "waybar"
spawn-at-startup "mako"
spawn-at-startup "xwayland-satellite"
```

## XWayland

`xwayland-satellite` provides XWayland support. Tell apps the DISPLAY is available:

```kdl
environment {
    DISPLAY ":0"
}
```
