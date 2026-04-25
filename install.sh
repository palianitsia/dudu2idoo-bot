#!/bin/bash

echo "========================================"
echo "   Dudu2idoo Bot - Installazione macOS"
echo "========================================"
echo

# Controlla Node.js
if ! command -v node &> /dev/null; then
    echo "[INFO] Node.js non trovato. Installazione automatica..."
    echo
    
    # Controlla Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Homebrew non trovato. Installazione in corso..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    echo "Installazione Node.js con Homebrew..."
    brew install node
    
    if [ $? -ne 0 ]; then
        echo "[ERRORE] Installazione Node.js fallita."
        echo "Scarica manualmente da: https://nodejs.org/"
        exit 1
    fi
    echo "[OK] Node.js installato!"
fi

echo "[OK] Node.js: $(node --version)"
echo

# Installa dipendenze
echo "Installazione dipendenze in corso..."
npm install --omit=dev

if [ $? -ne 0 ]; then
    echo "[ERRORE] Installazione fallita!"
    exit 1
fi

echo "[OK] Dipendenze installate"
echo

# Crea script di avvio
echo "Creazione script di avvio..."

cat > run.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
npm start
EOF

chmod +x run.sh

# Crea icona sul desktop
cat > "$HOME/Desktop/Dudu2idoo Bot.command" << EOF
#!/bin/bash
cd "$(pwd)"
npm start
EOF

chmod +x "$HOME/Desktop/Dudu2idoo Bot.command"

echo "[OK] Script creati"
echo

echo "========================================"
echo "   Installazione completata!"
echo "========================================"
echo
echo "Per avviare il bot:"
echo "   - Doppio click su 'Dudu2idoo Bot.command' sul Desktop"
echo "   - Oppure: ./run.sh nel terminale"
echo