# Installation

Standard Arch Linux install. After base install, install the following packages.

## Required packages

```bash
pacman -S \
    niri \
    xwayland-satellite \
    waybar \
    foot \
    mako \
    fuzzel \
    pipewire \
    wireplumber \
    pipewire-pulse \
    xdg-desktop-portal-gtk \
    seatd \
    acpid \
    sof-firmware \
    ttf-nerd-fonts-symbols-mono \
    brightnessctl
```

## Services

```bash
# seatd — seat management (required for niri on TTY)
systemctl enable --now seatd

# acpid — ACPI event handling (brightness keys)
systemctl enable --now acpid

# PipeWire audio (user services, start once logged in)
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

## User groups

```bash
usermod -aG seat,audio,video <username>
```

Log out and back in for group changes to take effect.

## Auto-start niri on TTY1

Add to `~/.bash_profile`:

```bash
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
    exec niri-session -l
fi
```

The `-l` flag is required — without it, `niri-session` re-execs into a new login shell
which re-sources `.bash_profile`, creating an infinite loop.
