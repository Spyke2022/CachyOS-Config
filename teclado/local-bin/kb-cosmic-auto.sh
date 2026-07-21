#!/usr/bin/env bash
# Reordena os layouts do COSMIC conforme a presenca do HyperX Alloy Elite 2.
# HyperX plugado  -> grupo 0 = us intl
# HyperX ausente  -> grupo 0 = br (ABNT2)
# Super+Espaco continua alternando manualmente entre os dois.

CFG="$HOME/.config/cosmic/com.system76.CosmicComp/v1/xkb_config"
VID="03f0"
PID="058f"

hyperx_presente() {
    local d
    for d in /sys/bus/usb/devices/*; do
        [ -r "$d/idVendor" ] || continue
        [ -r "$d/idProduct" ] || continue
        if [ "$(cat "$d/idVendor")" = "$VID" ] && [ "$(cat "$d/idProduct")" = "$PID" ]; then
            return 0
        fi
    done
    return 1
}

set_ordem() {
    local layout="$1" variant="$2"
    [ -f "$CFG" ] || { echo "xkb_config nao encontrado: $CFG" >&2; return 1; }

    # ja esta na ordem desejada -> nao mexe (evita loop de eventos inotify)
    if grep -q "layout:[[:space:]]*\"$layout\"" "$CFG" \
       && grep -q "variant:[[:space:]]*\"$variant\"" "$CFG"; then
        return 0
    fi

    local tmp
    tmp="$(mktemp)"
    sed -E "s|layout:[[:space:]]*\"[^\"]*\"|layout: \"$layout\"|; \
            s|variant:[[:space:]]*\"[^\"]*\"|variant: \"$variant\"|" "$CFG" > "$tmp"
    mv -f "$tmp" "$CFG"
    echo "ordem aplicada: $layout / $variant"
}

aplicar() {
    if hyperx_presente; then
        set_ordem "us,br" "intl,"
    else
        set_ordem "br,us" ",intl"
    fi
}

aplicar
udevadm monitor --udev --subsystem-match=usb | while read -r _linha; do
    sleep 1
    aplicar
done
