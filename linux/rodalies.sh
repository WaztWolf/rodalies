#!/usr/bin/env bash

set -e

HTML_URL="https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/rodalies.html"

TEMP_HTML="$(mktemp --suffix=.html)"

echo ""
echo "=============================================="
echo "        🚆 RODALIES CHAOS 🚆"
echo "=============================================="
echo ""

echo "[+] Descargando Rodalies Chaos..."

if ! curl -fsSL "$HTML_URL" -o "$TEMP_HTML"; then
    echo "[!] No se pudo descargar el HTML."
    rm -f "$TEMP_HTML"
    exit 1
fi

echo "[+] HTML descargado."

BROWSER=""

if command -v chromium >/dev/null 2>&1; then
    BROWSER="$(command -v chromium)"

elif command -v chromium-browser >/dev/null 2>&1; then
    BROWSER="$(command -v chromium-browser)"

elif command -v google-chrome >/dev/null 2>&1; then
    BROWSER="$(command -v google-chrome)"

elif command -v google-chrome-stable >/dev/null 2>&1; then
    BROWSER="$(command -v google-chrome-stable)"

elif command -v microsoft-edge >/dev/null 2>&1; then
    BROWSER="$(command -v microsoft-edge)"

elif command -v firefox >/dev/null 2>&1; then
    BROWSER="$(command -v firefox)"
fi

if [ -z "$BROWSER" ]; then
    echo "[!] No encuentro Chromium, Chrome, Edge ni Firefox."
    echo "[+] Abriendo el HTML con el sistema..."

    xdg-open "$TEMP_HTML" >/dev/null 2>&1 &
    exit 0
fi

echo "[+] Navegador encontrado: $BROWSER"
echo "[+] Lanzando Rodalies Chaos..."
echo ""

case "$(basename "$BROWSER")" in

    chromium|chromium-browser|google-chrome|google-chrome-stable|microsoft-edge)
        "$BROWSER" \
            --app="file://$TEMP_HTML" \
            --start-maximized \
            --disable-features=Translate \
            >/dev/null 2>&1 &
        ;;

    firefox)
        "$BROWSER" \
            "file://$TEMP_HTML" \
            >/dev/null 2>&1 &
        ;;

    *)
        xdg-open "$TEMP_HTML" >/dev/null 2>&1 &
        ;;
esac

echo "🚆 CAOS FERROVIARI ACTIVAT."
echo ""

exit 0
