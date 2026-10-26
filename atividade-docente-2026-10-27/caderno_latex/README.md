# Caderno LaTeX da atividade

O PDF final está em `../output/pdf/Caderno_Atividade_ANOVA_Tukey_Regressao.pdf`.

## Organização

- `main.tex`: documento principal.
- `preambulo.tex`: capa, identidade institucional, código e pranchas gráficas.
- `apresentacao.tex`: instruções de uso.
- `fundamentos.tex`: modelos e resultados centrais.
- `roteiro.tex`: roteiro de discussão derivado de `../ROTEIRO_DOCENTE.md`.
- `galeria.tex`: 19 pranchas com comentários e legendas.
- `script_integral.tex`: inclui as 722 linhas do arquivo `../atividade_docente.R` em 14 blocos, sem copiar seu conteúdo.
- `cobertura_script.txt`: intervalos de linhas e conferência de completude.
- `referencias.bib`: referências em BibLaTeX, backend BibTeX.
- `ueap-apostila.cls` e `Brasao_UEAP.png`: template institucional já utilizado na apostila.

O projeto depende dos arquivos R e das figuras em `../saidas/figuras/`. **Não mova somente esta pasta**: use o pacote completo, que preserva a estrutura. As figuras já estão incluídas; não é necessário executar R para compilar o documento.

## Compilação

Na pasta `caderno_latex`, execute:

```text
pdflatex -interaction=nonstopmode -halt-on-error main.tex
bibtex main
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```

Em PowerShell, `./compilar.ps1` automatiza a sequência e copia o PDF para a pasta de entrega. Requer MiKTeX ou TeX Live com os pacotes da classe (tcolorbox, listings, tikz, biblatex, csquotes, entre outros). Não é necessário shell escape.

## Atualizar conteúdo

`gerar_conteudo.py` transforma o roteiro Markdown em LaTeX e calcula os intervalos consecutivos de inclusão do script. Os `.tex` gerados já acompanham o projeto; Python não é necessário para recompilar a edição entregue. Se alterar o roteiro ou o número de linhas do script, execute `python gerar_conteudo.py` com uma instalação funcional de Python 3 e recompile. A função de geração verifica que a soma dos intervalos cobre integralmente o script, sem lacunas ou duplicações.

O código usa numeração contínua de linhas, fonte de 9 pt, espaçamento simples, aspas literais e destaque de sintaxe. Linhas extensas são quebradas visualmente, sem alteração do `.R`. Para executar, utilize o arquivo original e não uma cópia extraída do PDF.

## Validação editorial

Edição final: 47 páginas físicas, incluindo capa, apresentação, sumário, fundamentos, roteiro, 19 pranchas, apêndice integral e referências. Compilada em pdfLaTeX/MiKTeX e BibTeX, sem `Overfull`, referências indefinidas ou marcadores `??`. O aviso de backend alternativo BibTeX é informativo.

Todas as páginas foram renderizadas pelo Poppler e inspecionadas em pranchas; código e diagnóstico receberam inspeção ampliada. Conferidos os 14 intervalos do apêndice e a inclusão das 722 linhas. O motor de prévia interno do aplicativo não retornou diagnóstico em tempo útil; a compilação e a validação utilizaram o compilador local e o PDF efetivamente gerado. Nenhum fonte foi modificado pela tentativa de prévia.
