# Known Issues & Fixes

## niri not starting on TTY1 — infinite loop

**Symptom:** After login on TTY1, the shell hangs at ~35% CPU doing nothing.
**Cause:** Calling `exec niri-session` (without `-l`) from `.bash_profile` causes
`niri-session` to re-exec into a new login shell, which re-sources `.bash_profile`,
which calls `niri-session` again — infinite loop.
**Fix:** Pass the `-l` flag: `exec niri-session -l`

---

## Brightness keys not working

**Symptom:** F5/F6 do nothing. `wev` shows no events when pressing them.
**Cause:** The `ideapad_laptop` kernel module intercepts ACPI brightness events
and applies them at the kernel level, never forwarding them as input events to
the compositor.
**Failed attempt:** Adding `acpi_backlight=native` to kernel parameters — caused
the laptop to not boot (Intel Arc/Meteor Lake GPU fails to initialize the backlight
without ACPI involvement on this hardware).
**Fix:** Install `acpid` and handle the events directly:

```
/etc/acpi/events/bl_down:
  event=video/brightnessdown.*
  action=/etc/acpi/handlers/backlight.sh -

/etc/acpi/events/bl_up:
  event=video/brightnessup.*
  action=/etc/acpi/handlers/backlight.sh +

/etc/acpi/handlers/backlight.sh:
  brightnessctl --device=intel_backlight set 5%[+-]
```

---

## Intermittent boot hang (GPU driver conflict)

**Symptom:** System occasionally hangs at boot with a black screen.
**Cause:** Both `i915` and `xe` kernel modules claim the Intel Arc (Meteor Lake-P)
GPU. When `xe` loads first or both race, the display subsystem can deadlock.
**Fix:** Blacklist the `xe` driver — `i915` handles Meteor Lake reliably:

```bash
echo "blacklist xe" > /etc/modprobe.d/blacklist-xe.conf
mkinitcpio -P
```

**Recovery:** If the system hangs at boot, add `i915.modeset=0` at the rEFInd
boot menu (not `nomodeset` — that disables all KMS and breaks niri).

---

## Audio firmware errors at boot

**Symptom:** `sof-audio-pci-intel-mtl: SOF firmware and/or topology file not found`
**Cause:** `sof-firmware` package not installed.
**Fix:**

```bash
pacman -S sof-firmware
```

---

## Waybar — sway modules disabled warnings

**Symptom:** Waybar logs full of `Disabling module "sway/workspaces"` etc.
**Cause:** Default Waybar config at `/etc/xdg/waybar/config.jsonc` is written for Sway.
**Fix:** Create `~/.config/waybar/config.jsonc` using `niri/workspaces` and
`niri/window` modules instead.

---

## Waybar — no icons

**Symptom:** Icon placeholders show as empty boxes.
**Cause:** `ttf-font-awesome` was replaced by `woff2-font-awesome` upstream.
Waybar (GTK) cannot use `.woff2` format.
**Fix:** Install `ttf-nerd-fonts-symbols-mono` and reference `"Symbols Nerd Font Mono"`
in `style.css`.

---

## pipewire-pulse not running after install

**Symptom:** Volume keys have no effect. Waybar volume module empty.
**Cause:** `pipewire-pulse.service` is not enabled by default.
**Fix:**

```bash
systemctl --user enable --now pipewire-pulse
```
