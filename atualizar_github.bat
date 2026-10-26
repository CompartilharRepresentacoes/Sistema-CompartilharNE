@echo off
pushd "%~dp0"
echo ===============================================
echo   Atualizando Sistema CompartilharNE no GitHub
echo ===============================================
echo.

if not exist ".git" (
    echo ERRO: esta pasta nao e o repositorio do sistema.
    echo Coloque este .bat dentro da pasta Sistema-CompartilharNE.
    goto FIM
)

echo Arquivos alterados nesta pasta:
git status --short
echo.

git add -A
set /p MSG="Descreva a atualizacao (ou so aperte Enter): "
if "%MSG%"=="" set MSG=Atualizacao em %date% %time%
git commit -m "%MSG%"

echo.
echo Buscando atualizacoes do GitHub antes de enviar...
git pull --rebase
if errorlevel 1 (
    echo.
    echo ERRO ao juntar com a versao do GitHub. Tire um print desta tela e me mande.
    goto FIM
)

git push
if errorlevel 1 (
    echo.
    echo ERRO ao enviar para o GitHub. Tire um print desta tela e me mande.
    goto FIM
)

echo.
echo ===============================================
echo   Concluido! Confira em:
echo   https://github.com/CompartilharRepresentacoes/Sistema-CompartilharNE
echo ===============================================

:FIM
echo.
popd
pause
