# Waybar Setup

## Config location

`~/.config/waybar/config.jsonc` and `~/.config/waybar/style.css`

## Niri modules

Waybar has native niri support. Use `niri/workspaces` and `niri/window`
instead of the sway equivalents (which are disabled on niri).

## Icons

Font Awesome 7 ships only `.woff2` files which GTK/Waybar cannot use.
Install `ttf-nerd-fonts-symbols-mono` instead — it provides icon glyphs in TTF format.

```bash
pacman -S ttf-nerd-fonts-symbols-mono
```

Reference in `style.css`:

```css
* {
    font-family: "Symbols Nerd Font Mono", monospace;
}
```
