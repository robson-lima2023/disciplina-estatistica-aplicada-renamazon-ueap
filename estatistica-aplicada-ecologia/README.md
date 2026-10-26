# Estatística Aplicada à Ecologia, Biodiversidade e Recursos Naturais Amazônicos

Material didático de apoio ao RENAmazon/UEAP. Autor: Prof. Dr. Robson Borges de Lima. Edição 2026, versão 1.0.

## Estudar e ensinar

Leia `apostila_estatistica_aplicada.pdf`. As sete unidades têm fundamentos, exemplos interpretados, de quatro a cinco exercícios e um script completo ao final. O gabarito reúne respostas e critérios de interpretação. A versão impressa dos scripts é importada diretamente dos arquivos `.R`, evitando cópias divergentes.

Os exemplos abrangem aves e paisagens, qualidade da água e decomposição. Todos os dados são **simulados para ensino**, com semente 20261026. Nenhum resultado é uma estimativa real sobre o Amapá ou a Amazônia.

## Começar no RStudio

1. Instale R e RStudio, se necessário.
2. Abra `estatistica-aplicada-ecologia.Rproj` (não apenas um script isolado).
3. No console, execute uma vez: `install.packages("ggplot2")`.
4. Abra `scripts_r/01_fundamentos.R` e execute por blocos com Ctrl+Enter.
5. Avance na ordem numérica. Os CSV já estão na pasta `dados`; cada roteiro pode ser executado separadamente, a partir da raiz do projeto.

Os códigos utilizam sobretudo R básico e apenas um pacote adicional, ggplot2. Não é preciso programar funções ou laços para resolver os exercícios. Os comentários indicam a questão resolvida, a unidade de análise e os cuidados de interpretação. A função anônima pontual em `aggregate()` serve apenas para agrupar os quantis.

## Reproduzir tudo

Na raiz do projeto, execute `source("executar_tudo.R", encoding="UTF-8")`, ou `Rscript executar_tudo.R` no terminal. O executor usa um laço simples apenas para automatizar os arquivos; o aluno pode trabalhar sem ele.

- `00_gerar_dados.R`: recria os cinco CSV com semente fixa; sobrescreve apenas os CSV didáticos do projeto.
- `01_fundamentos.R` a `07_integrador.R`: resolvem os exercícios e produzem as figuras e saídas.
- `validar_resultados.R`: confere estrutura e resultados centrais usados no texto.
- `figuras/`: gráficos vetoriais PDF.
- `resultados/`: tabelas e relatórios curtos.
- `logs/`: execução por script e `sessionInfo.txt`, com versões dos pacotes e do R.

Os CSV usam vírgula para campos e ponto decimal. Não edite no Excel sem verificar separadores e codificação. A variável Shannon é sintética e respeita H <= log(S); não foi calculada de uma matriz real de espécies. Consulte `dados/DICIONARIO.md` para as unidades e estruturas.

Validação realizada com R 4.4.2 e ggplot2 4.0.0. A instalação local informa que ggplot2 foi construído no R 4.4.3; a execução terminou sem erros. As versões completas constam no registro de sessão. Diferenças de versão podem alterar mensagens ou aparência dos gráficos.

## Compilar LaTeX

O projeto usa a classe institucional `ueap-apostila.cls`, copiada da apostila local de Ordenação Multivariada em Ecologia com R. Pacotes principais: babel, geometry, lmodern, tikz, tcolorbox, listings, amsmath, booktabs, fancyhdr, biblatex e csquotes.

Com MiKTeX ou TeX Live e BibTeX disponíveis, execute na raiz:

```text
pdflatex -interaction=nonstopmode -halt-on-error main.tex
bibtex main
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```

Em PowerShell, `./compilar.ps1` automatiza a sequência e copia o resultado para `apostila_estatistica_aplicada.pdf`. Em outros sistemas, use a sequência acima. Os gráficos já estão incluídos; para regenerá-los, execute primeiro o R. O compilador gera `main.pdf`, equivalente ao arquivo de entrega. Não é necessário shell escape.

A bibliografia usa BibLaTeX em estilo autor-data com backend BibTeX, disponível neste ambiente. Isso preserva o padrão de citações do template e evita exigir Biber. O aviso de backend alternativo é informativo. Não altere o backend sem adaptar o comando de compilação.

## Adaptar à dissertação

Crie outra cópia e preserve os dados originais. Documente a pergunta, seleção dos locais, unidade experimental/amostral, repetições, esforço e escalas ambientais. Revise distribuição, dependência, variâncias, preditores e família de comparações. Não apresente resultados simulados como resultados de campo. `lm()` para Shannon não autoriza usar o mesmo modelo para qualquer contagem de riqueza ou abundância.

## Fontes e revisão

`DIAGNOSTICO_EDITORIAL.md` registra consultas e decisões. `VALIDACAO.md` documenta execução e inspeção editorial. Os repositórios de referência foram preservados. O brasão foi reutilizado do material institucional indicado pelo autor; não se acrescentaram logotipos externos.
