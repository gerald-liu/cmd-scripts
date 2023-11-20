setlocal
set "wd=D:\OneDrive - HKUST Connect\Learning\Learning_MFin\FINA5360\Assignments"
cd %wd%
for %%f in (*.md) do (
    pandoc --pdf-engine=xelatex %%f -o %%~nf.pdf
)
pause
endlocal