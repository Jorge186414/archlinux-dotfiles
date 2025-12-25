#!/bin/bash

# Carpeta con wallpapers
WALLPAPER_DIR="$HOME/Downloads/wallpapers_anime"

# Obtener lista de monitores activos desde hyprctl
MONITORS=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

# Obtener lista aleatoria de wallpapers
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf))

# Verificar que hay suficientes wallpapers
if [ ${#WALLPAPERS[@]} -lt $(echo "$MONITORS" | wc -l) ]; then
    echo "No hay suficientes wallpapers para la cantidad de monitores"
    exit 1
fi

# Crear archivo de configuración temporal para Hyprpaper
CONFIG_FILE="/tmp/hyprpaper.conf"
echo "" > "$CONFIG_FILE"

INDEX=0
for MON in $MONITORS; do
    WP=${WALLPAPERS[$INDEX]}
    echo "preload = $WP" >> "$CONFIG_FILE"
    echo "wallpaper = $MON,$WP" >> "$CONFIG_FILE"
    ((INDEX++))
done

# Reiniciar Hyprpaper con nueva config
pkill hyprpaper
hyprpaper -c "$CONFIG_FILE" &
