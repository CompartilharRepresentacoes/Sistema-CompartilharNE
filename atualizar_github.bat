@echo off
cd /d "%~dp0"
echo ===============================================
echo   Atualizando Sistema CompartilharNE no GitHub
echo ===============================================
echo.

git add .

set /p MSG="Descreva a atualizacao (ou so aperte Enter): "
if "%MSG%"=="" set MSG=Atualizacao em %date% %time%

git commit -m "%MSG%"
if errorlevel 1 (
    echo.
    echo Nada novo para enviar ou houve um erro no commit acima.
)

git push

echo.
echo ===============================================
echo   Concluido! Confira em:
echo   https://github.com/CompartilharRepresentacoes/Sistema-CompartilharNE
echo ===============================================
echo.
pause
