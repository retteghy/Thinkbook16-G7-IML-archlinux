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

## Hibernate setup

Create a 32GB swapfile (adjust to your RAM size):

```bash
fallocate -l 32G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab
```

Get the resume parameters:

```bash
RESUME_UUID=$(findmnt -n -o UUID /)
RESUME_OFFSET=$(filefrag -v /swapfile | awk '$1 == "0:" { gsub(/\./, "", $4); print $4 }')
```

Add to boot parameters (see [Boot parameters](#boot-parameters)):

```
resume=UUID=<RESUME_UUID> resume_offset=<RESUME_OFFSET>
```

Add the `resume` hook to `/etc/mkinitcpio.conf` after `filesystems`:

```
HOOKS=(... filesystems resume fsck)
```

Rebuild initramfs:

```bash
mkinitcpio -P
```

## Boot parameters

This machine requires specific kernel parameters. Add to your bootloader config:

```
resume=UUID=<root-uuid> resume_offset=<swapfile-offset> module_blacklist=xe i915.enable_psr=0
```

- `module_blacklist=xe` — prevents the `xe` driver from racing with `i915` on boot (see [issues](issues.md))
- `i915.enable_psr=0` — disables Panel Self Refresh, prevents intermittent display hangs
- `resume=` / `resume_offset=` — required for hibernate to work with a swapfile
