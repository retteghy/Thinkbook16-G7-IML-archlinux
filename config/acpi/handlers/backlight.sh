#!/bin/sh
case "$1" in
    -) brightnessctl --device=intel_backlight set 5%- ;;
    +) brightnessctl --device=intel_backlight set 5%+ ;;
esac
