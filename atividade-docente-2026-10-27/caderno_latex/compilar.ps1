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
  New-Item -ItemType Directory -Force ..\output\pdf | Out-Null
  Copy-Item -LiteralPath main.pdf -Destination ..\output\pdf\Caderno_Atividade_ANOVA_Tukey_Regressao.pdf -Force
} finally { Pop-Location }
