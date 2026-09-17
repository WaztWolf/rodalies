#!/usr/bin/env bash

set -e

HTML_URL="https://raw.githubusercontent.com/WaztWolf/rodalies/main/rodalies.html"

has_display() {
    [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]
}

FRASES=(
    "Servei Rodalies de Catalunya 💜"
    "Retard indefinit ⚠️"
    "Incidència tècnica 🚧"
    "Disculpin les molèsties 🙃"
    "Circulació interrompuda 🛑"
    "El tren no passarà 🫠"
    "Servei mínim 😭"
    "Caos ferroviari 💀"
    "Tren suprimit ❌🚆"
    "Retard acumulat ⚠️"
    "Incidència a la línia 🚧"
    "Esperin indicacions 📢"
    "Gràcies per la seva paciència 🙂"
    "Servei afectat 💀"
    "Pròxim tren: probablement"
    "ATENCIÓ PASSATGERS ⚠️"
    "NO HI HA TREN 😭"
    "Rodalies moment™"
    "Renfe diu que tot va bé 👍"
    "Circulació amb alteracions"
    "El tren està arribant... o no"
    "AVÍS IMPORTANT 📢"
    "CANVI DE VIA 🚨"
    "TREN CANCEL·LAT 💀"
)

PARADAS=(
    "Mataró" "Arenys de Mar" "Calella" "Blanes" "Maçanet-Massanes"
    "Badalona" "Sant Adrià de Besòs" "Barcelona Sants"
    "Barcelona Passeig de Gràcia" "El Prat de Llobregat" "Aeroport"
    "Sitges" "Vilanova i la Geltrú" "Granollers Centre"
    "Mollet-Sant Fost" "Vic" "Ripoll" "Puigcerdà"
)

COLORS=(31 32 33 34 35 36 91 92 93 94 95 96)
terminal_cleanup() {
    tput cnorm 2>/dev/null || true
    tput sgr0  2>/dev/null || true
    tput rmcup 2>/dev/null || true
    clear 2>/dev/null || true
}

terminal_chaos() {
    echo ""
    echo "=============================================="
    echo "   Modo terminal: 🚆 RODALIES CHAOS 🚆"
    echo "=============================================="
    echo "   (Ctrl+C para salir)"
    echo ""
    sleep 1

    trap terminal_cleanup INT TERM EXIT

    tput smcup 2>/dev/null || true   
    tput civis 2>/dev/null || true   

    local paradaIndex=0

    while true; do
        local rows cols
        rows=$(tput lines)
        cols=$(tput cols)

        clear

        # Panel superior, estilo pantalla de andén
        local parada="${PARADAS[$((paradaIndex % ${#PARADAS[@]}))]}"
        local mensajes=(
            "Próxima Parada: $parada ⚠️"
            "PROPERA PARADA: $parada 🚆"
            "ATENCIÓ: $parada 🚨"
            "DESTÍ: $parada 💜"
        )
        local msg="${mensajes[$((RANDOM % ${#mensajes[@]}))]}"

        tput cup 0 0
        printf "\e[42;30;1m%-${cols}s\e[0m" " 🚆 $msg"

        # Frases caóticas repartidas por la pantalla
        local n_frases=6
        (( rows < 12 )) && n_frases=3

        for ((i = 0; i < n_frases; i++)); do
            local frase="${FRASES[$((RANDOM % ${#FRASES[@]}))]}"
            local color="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"

            local max_row=$((rows - 3))
            (( max_row < 1 )) && max_row=1
            local row=$((RANDOM % max_row + 2))

            local max_col=$((cols - ${#frase}))
            (( max_col < 1 )) && max_col=1
            local col=$((RANDOM % max_col))

            tput cup "$row" "$col"
            printf "\e[1;%sm%s\e[0m" "$color" "$frase"
        done

        # "Flash" aleatorio (pantalla en blanco un instante)
        if (( RANDOM % 10 < 2 )); then
            printf "\e[47m"
            local r
            for ((r = 1; r <= rows; r++)); do
                tput cup "$r" 0
                printf "%${cols}s" ""
            done
            printf "\e[0m"
            sleep 0.08
        fi

        tput cup "$((rows - 1))" 0
        printf "\e[2mCtrl+C per sortir · RODALIES CHAOS MODE 🚆💀\e[0m"

        sleep 0.35
        paradaIndex=$((paradaIndex + 1))
    done
}

graphical_chaos() {
    local TEMP_HTML
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

    local BROWSER=""

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

        if command -v xdg-open >/dev/null 2>&1; then
            echo "[!] No encuentro Chromium, Chrome, Edge ni Firefox."
            echo "[+] Abriendo el HTML con el sistema..."
            xdg-open "$TEMP_HTML" >/dev/null 2>&1 &
            exit 0
        fi

        echo "[!] No hay navegador ni xdg-open disponibles."
        echo "[+] Este sistema no tiene forma de mostrar el HTML: cambiando a modo terminal."
        terminal_chaos
        return
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
}

FORCE_TERMINAL=false

for arg in "$@"; do
    case "$arg" in
        --terminal|--tty|-t)
            FORCE_TERMINAL=true
            ;;
    esac
done

if [ "$FORCE_TERMINAL" = true ]; then
    terminal_chaos
elif has_display; then
    graphical_chaos
else
    echo "[i] No se ha detectado entorno gráfico (\$DISPLAY / \$WAYLAND_DISPLAY vacíos)."
    terminal_chaos
fi
