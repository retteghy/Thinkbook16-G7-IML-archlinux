# Arch Linux on Lenovo ThinkBook 16 G7 IML

Personal setup notes for running Arch Linux with the [niri](https://github.com/YaLTeR/niri) scrollable-tiling Wayland compositor on a Lenovo ThinkBook 16 G7 IML.

## Hardware

- **CPU:** Intel Core Ultra 7 (Meteor Lake)
- **GPU:** Intel Arc Graphics (Meteor Lake-P)
- **Audio:** Intel SOF (Sound Open Firmware) — MTL
- **Keyboard:** German layout (de-latin1-nodeadkeys)

## What works

- niri Wayland compositor
- Waybar with niri modules
- Brightness keys (via acpid)
- Volume keys (via WirePlumber/wpctl)
- Touchpad (tap, natural scroll)
- Audio (PipeWire + WirePlumber)
- XWayland (via xwayland-satellite)
- Hibernate and hybrid-sleep

## Contents

- [Installation](docs/installation.md) — base packages, hibernate setup, boot parameters
- [niri](docs/niri.md) — Wayland compositor setup and config
- [Waybar](docs/waybar.md) — status bar setup
- [Known issues & fixes](docs/issues.md) — what broke and how it was fixed

## Config files

| File | Description |
|------|-------------|
| `config/niri/config.kdl` | niri compositor config |
| `config/waybar/config.jsonc` | Waybar config |
| `config/waybar/style.css` | Waybar stylesheet |
| `config/foot/foot.ini` | foot terminal config |
| `config/acpi/handlers/backlight.sh` | ACPI brightness handler |
| `config/acpi/events/bl_down` | ACPI brightness-down event |
| `config/acpi/events/bl_up` | ACPI brightness-up event |
| `config/modprobe/blacklist-xe.conf` | Blacklist Intel xe GPU driver |
| `config/logind/lid.conf` | Lid close behavior (hibernate/hybrid-sleep) |
| `config/sleep/hibernate.conf` | Sleep state configuration |
