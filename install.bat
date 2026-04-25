@echo off
echo ========================================
echo    Dudu2idoo Bot - Installazione
echo ========================================
echo.

REM Controlla se Node.js è installato
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Node.js non trovato. Installazione automatica...
    echo.
    
    REM Scarica Node.js LTS
    echo Download di Node.js in corso...
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi' -OutFile '%TEMP%\node-installer.msi'"
    
    if exist "%TEMP%\node-installer.msi" (
        echo Installazione Node.js in corso. Attendere...
        msiexec /i "%TEMP%\node-installer.msi" /quiet /norestart
        if %errorlevel% equ 0 (
            echo [OK] Node.js installato con successo!
        ) else (
            echo [ERRORE] Installazione Node.js fallita.
            echo Scarica manualmente da: https://nodejs.org/
            pause
            exit /b 1
        )
        del "%TEMP%\node-installer.msi"
    ) else (
        echo [ERRORE] Download fallito.
        echo Scarica manualmente Node.js da: https://nodejs.org/
        pause
        exit /b 1
    )
    
    REM Aggiorna PATH
    set PATH=%PATH%;%ProgramFiles%\nodejs
)

echo [OK] Node.js trovato: 
node --version
echo.

REM Installa le dipendenze
echo Installazione dipendenze in corso...
call npm install --omit=dev

if %errorlevel% neq 0 (
    echo [ERRORE] Installazione fallita!
    pause
    exit /b 1
)

echo [OK] Dipendenze installate
echo.

REM Crea shortcut desktop
echo Creazione collegamento sul desktop...
set ELECTRON_PATH=%CD%\node_modules\.bin\electron.cmd
if exist "%ELECTRON_PATH%" (
    powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut(\"$env:USERPROFILE\\Desktop\\Dudu2idoo Bot.lnk\"); $SC.TargetPath = \"%ELECTRON_PATH%\"; $SC.Arguments = \"%CD%\"; $SC.WorkingDirectory = \"%CD%\"; $SC.Save()"
) else (
    powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut(\"$env:USERPROFILE\\Desktop\\Dudu2idoo Bot.lnk\"); $SC.TargetPath = \"cmd.exe\"; $SC.Arguments = \"/c cd /d \"\"%CD%\"\" && npm start\"; $SC.WorkingDirectory = \"%CD%\"; $SC.IconLocation = \"%CD%\\assets\\icon.ico\"; $SC.Save()"
)
echo [OK] Collegamento creato

echo.
echo ========================================
echo    Installazione completata!
echo ========================================
echo.
echo Per avviare il bot: clicca sull'icona sul desktop
echo.
pause