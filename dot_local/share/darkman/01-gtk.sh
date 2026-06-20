#!/bin/sh

# Switch the GTK Theme and preffered color-scheme.

case "$1" in
dark)
  THEME=Adwaita-dark
  COLOR=prefer-dark
  ;;
light)
  THEME=Adwaita
  COLOR=prefer-light
  ;;
default) exit 1 ;;
esac

gsettings set org.gnome.desktop.interface color-scheme "$COLOR"
gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
