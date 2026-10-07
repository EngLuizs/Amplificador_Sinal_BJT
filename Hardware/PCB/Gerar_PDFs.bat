@echo off
echo Gerando PDFs de Fabricacao mantendo o Template Personalizado...

:: ==========================================
:: CONFIGURAÇÃO DO PROJETO - Mude apenas aqui!
:: ==========================================
set PROJ_NAME=PCB-FLM-AS
:: ==========================================

:: Caminhos das ferramentas do KiCad
set KICAD_CLI="C:\Program Files\KiCad\10.0\bin\kicad-cli.exe"
set KICAD_PYTHON="C:\Program Files\KiCad\10.0\bin\python.exe"

set ORIGINAL_PCB=%PROJ_NAME%.kicad_pcb
set ORIGINAL_PRO=%PROJ_NAME%.kicad_pro
set TEMP_PCB=temp_export.kicad_pcb
set TEMP_PRO=temp_export.kicad_pro

:: Copia o arquivo de projeto (.kicad_pro) para que o KiCad saiba qual template usar
if exist "%ORIGINAL_PRO%" copy "%ORIGINAL_PRO%" "%TEMP_PRO%" >nul

:: 1. Top Solder (Pagina 1 de 4)
%KICAD_PYTHON% -c "d=open('%ORIGINAL_PCB%','r',encoding='utf-8').read().replace('CH_PAGINA','1').replace('CH_TOTAL','3'); open('%TEMP_PCB%','w',encoding='utf-8').write(d)"
%KICAD_CLI% pcb export pdf --layers "F.SilkS,Edge.Cuts,User.Comments" --include-border-title --drill-shape-opt 1 --output "01_Top_Solder.pdf" %TEMP_PCB%

:: 3. Bottom Layer (ESPELHADO - Pagina 3 de 4)
%KICAD_PYTHON% -c "d=open('%ORIGINAL_PCB%','r',encoding='utf-8').read().replace('CH_PAGINA','2').replace('CH_TOTAL','3'); open('%TEMP_PCB%','w',encoding='utf-8').write(d)"
%KICAD_CLI% pcb export pdf --layers "B.Cu,Edge.Cuts,User.Comments" --include-border-title --drill-shape-opt 1 --mirror --output "03_Bottom_Layer.pdf" %TEMP_PCB%

:: 4. Bottom Solder (ESPELHADO - Pagina 4 de 4)
%KICAD_PYTHON% -c "d=open('%ORIGINAL_PCB%','r',encoding='utf-8').read().replace('CH_PAGINA','3').replace('CH_TOTAL','3'); open('%TEMP_PCB%','w',encoding='utf-8').write(d)"
%KICAD_CLI% pcb export pdf --layers "B.Mask,Edge.Cuts,User.Comments" --include-border-title --drill-shape-opt 1 --mirror --output "04_Bottom_Solder.pdf" %TEMP_PCB%

:: Limpa os arquivos temporarios criados para deixar a pasta limpa
if exist %TEMP_PCB% del %TEMP_PCB%
if exist %TEMP_PRO% del %TEMP_PRO%

echo.
echo PDFs do projeto %PROJ_NAME% gerados com seu template!
pause