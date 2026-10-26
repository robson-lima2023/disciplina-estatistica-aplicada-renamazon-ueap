# Registro de validação — 26/10/2026

## Entrega

- PDF final: `apostila_estatistica_aplicada.pdf`, 42 páginas físicas (capa, três páginas preliminares e 38 páginas numeradas no corpo).
- Sete unidades, 31 exercícios, sete roteiros de resolução completos e gabarito comentado.
- Cinco bases CSV simuladas com dicionário; gerador com semente fixa; 13 figuras vetoriais PDF; fontes LaTeX e referências BibLaTeX; executor geral e compilador PowerShell.

## Computação e estatística

O executor geral terminou sem erros. Cada um dos sete roteiros foi também executado com Rscript em um processo independente, sem objetos herdados de outra unidade. As saídas estão em `logs/isolado_*.txt`; os registros do executor, em `logs/0*.R.txt`. Asserções de `validar_resultados.R` passaram: identificadores, replicação, limites biológicos, coerência H <= log(S), decomposição da soma de quadrados e resultados centrais de Welch, ANOVA e regressão.

Conferidos contra as saídas: diferença de oxigênio 0,98333 mg/L, IC95% 0,57754 a 1,38913; F do DIC aproximadamente 34,18; diferença Alta–Baixa de 17,62375 pontos percentuais e IC simultâneo; regressão simples de inclinação 0,02601159 e RMSE 0,2365055; coeficiente parcial de topografia 0,02686699 no modelo múltiplo. Textos e gabarito usam arredondamentos apropriados.

R 4.4.2 e ggplot2 4.0.0; sessão registrada. Avisos não impeditivos: ggplot2 construído sob R 4.4.3 e página de código da localidade Windows. Não houve erro de execução; os arquivos R didáticos usam caracteres ASCII nos comandos e comentários para reduzir problemas de codificação. As mensagens de diagnóstico são as do R, podendo incluir inglês.

## LaTeX e revisão visual

Compilação real em pdfLaTeX/MiKTeX, com BibTeX e passagens adicionais até resolver referências e sumário. Log final sem caixas sobrepostas `Overfull`, citações indefinidas, referências indefinidas ou destinos duplicados. Permanece o aviso informativo de BibLaTeX sobre o backend alternativo BibTeX, documentado no README.

As 42 páginas finais foram renderizadas em PNG pelo Poppler e inspecionadas em pranchas, verificando capa, sumário, títulos, caixas, fórmulas, tabelas, figuras, rodapés e transições. Houve inspeção ampliada de página de script e de oficina de interpretação; comparada também a capa do template de referência. Corrigidos: duas páginas vazias herdadas, duplicação de destinos, texto acentuado em matemática, cabeçalhos preliminares, numeração duplicada dos exercícios e quebra do título da unidade 7.

Verificação de extração de texto: 42 páginas com conteúdo, sem marcadores `??`. Os roteiros têm páginas próprias e fonte de 9 pt, com destaque de sintaxe. Oficinas de interpretação aproveitam páginas de exercícios sem comprimir a leitura. Os gráficos são vetoriais. O renderizador informou fontes de exibição Symbol/ArialUnicode não disponíveis; a inspeção das figuras renderizadas não mostrou perda de sinais ou rótulos.

## Limites documentados

As bases são simulações didáticas, não validação empírica de padrões amazônicos. Não se estimou detectabilidade, dependência espacial real ou modelos de contagens avançados. O material discute quando revisar essas condições. Não foram examinados todos os materiais da pasta de apoio; o diagnóstico registra precisamente o que foi consultado. O repositório e o template originais foram preservados.
