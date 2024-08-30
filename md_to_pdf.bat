setlocal

set "wd=D:\workspace\test"
cd %wd%

for %%f in (*.md) do (
    @REM ~n modifier extracts the name of the file without its extension.
    pandoc --pdf-engine=xelatex %%f -o %%~nf.pdf
    echo %%~nf.pdf knitted.
)

endlocal
