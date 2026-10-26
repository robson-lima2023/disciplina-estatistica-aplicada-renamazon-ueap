$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
  & pdflatex -interaction=nonstopmode -halt-on-error main.tex
  if ($LASTEXITCODE -ne 0) { throw 'Falha na primeira compilacao.' }
  & bibtex main
  if ($LASTEXITCODE -ne 0) { throw 'Falha nas referencias.' }
  & pdflatex -interaction=nonstopmode -halt-on-error main.tex
  if ($LASTEXITCODE -ne 0) { throw 'Falha na segunda compilacao.' }
  & pdflatex -interaction=nonstopmode -halt-on-error main.tex
  if ($LASTEXITCODE -ne 0) { throw 'Falha na compilacao final.' }
  Copy-Item -LiteralPath main.pdf -Destination apostila_estatistica_aplicada.pdf -Force
} finally { Pop-Location }
