# Oficina docente — ANOVA, teste F, Tukey e regressão em ecologia

**Aula de 27 de outubro de 2026 · RENAmazon / UEAP**  
Prof. Dr. Robson Borges de Lima

Atividade preparada para condução pelo professor, com código em nível de análise de pesquisa: auditoria, funções auxiliares, cálculos explícitos, diagnósticos, análises de sensibilidade e gráficos editáveis. A exposição pode ser graduada pela escolha das seções, sem reduzir o rigor do script.

## Abrir e usar amanhã

1. Extraia o pacote completo para uma pasta local.
2. Abra **`atividade-docente.Rproj`** no RStudio.
3. Instale uma única dependência, se necessário: `install.packages("ggplot2")`.
4. Abra **`atividade_docente.R`** e execute as seções. Para gerar tudo: `source("atividade_docente.R", encoding = "UTF-8")`.
5. Para projetar imediatamente, abra **`saidas/relatorio_aula.html`** no navegador. A galeria já foi gerada e funciona sem internet, desde que sua pasta de figuras acompanhe o HTML.

O relatório reúne os comentários calculados nesta execução e **19 figuras/painéis**, disponíveis também em PNG e PDF vetorial. Em uma sessão interativa, cada figura aparece ao ser produzida; altere `exibir_graficos <- FALSE` para apenas exportar. `B <- 4999L` define o número de realocações da extensão de randomização.

## Arquivos

**Caderno em PDF/LaTeX:** `output/pdf/Caderno_Atividade_ANOVA_Tukey_Regressao.pdf` reúne roteiro, fundamentos, 19 pranchas e o script integral de 722 linhas. Os fontes e instruções estão em `caderno_latex/README.md`.

| Arquivo/pasta | Uso |
|---|---|
| `atividade_docente.R` | Script principal, com 13 seções temáticas |
| `ROTEIRO_DOCENTE.md` | Sequência de aula, perguntas e respostas esperadas |
| `dados/` | Três CSV copiados da apostila e dicionário original |
| `saidas/relatorio_aula.html` | Galeria para projeção com comentários dos resultados |
| `saidas/figuras/` | 19 figuras/painéis, cada um em PNG e PDF |
| `saidas/tabelas/` | Estimativas, ANOVAs, Tukey, diagnósticos, predições e sensibilidade |
| `saidas/comentarios_resultados.txt` | Interpretações produzidas com os resultados da execução |
| `saidas/modelos_e_resultados.rds` | Modelos e resultados para reutilização no R |
| `saidas/execucao_completa.txt` | Registro da execução validada |
| `saidas/sessionInfo.txt` | Versões do R, pacotes e ambiente |
| `VALIDACAO.md` | Verificações numéricas, gráficas e limites |
| `validar_atividade.R` | Conferências independentes de F, Tukey, HC3 e LOO |

## Conteúdo central

- Exploração com pontos individuais, boxplots, histogramas, estratificação e escalas comuns.
- ANOVA reconstruída por somas de quadrados; verificação do F; distribuição nula e região crítica.
- Magnitude global por eta² e omega², sem classificações universais.
- Tukey com diferenças na escala original e IC simultâneos; médias e IC individuais em outro gráfico.
- Regressão simples: equação, equivalência F = t², IC da média versus predição de um novo local.
- Regressão múltipla: centralização, escalas interpretáveis, testes F parciais e efeitos condicionais.
- Diagnósticos de resíduos, alavancagem e Cook; sem exclusão automática de observações.

## Extensões para discussão avançada

- ANOVA de Welch como sensibilidade à heterogeneidade de variâncias.
- Teste de randomização do DIC, com nulidade aguda, mecanismo de alocação e resolução Monte Carlo explícitos.
- Covariância HC3 implementada pela fórmula matricial e IC normais assintóticos, diferenciados dos IC t clássicos.
- Interação topografia × ambiente identificada como exploratória, sem seleção automática do modelo por p.
- Sensibilidade leave-one-out e comparação entre erro de ajuste e erro LOO; nenhuma alegação de validação regional externa.
- DBC como experimento separado, com ajuste para bloco e comparação de tratamentos.

## Natureza dos dados e cuidados de interpretação

Todos os dados são **simulados**, já usados na apostila. O script não cria novos dados e não altera os CSV. O DIC tem 24 recipientes independentes; o estudo de aves tem 36 localidades, 12 por ambiente; o DBC tem 18 unidades em seis blocos completos.

O dicionário copiado descreve também bases da apostila que não são necessárias nesta oficina. Aqui são distribuídos somente `experimento_decomposicao.csv`, `comunidades_amazonicas.csv` e `decomposicao_blocos.csv`.

O índice de Shannon é uma variável sintética coerente com H ≤ log(S), sem matriz de espécies real subjacente. A riqueza foi ajustada durante a simulação para garantir essa coerência e não deve servir de exemplo de resposta Poisson pura. A inferência sobre ambientes é observacional; os resultados não estimam padrões reais da Amazônia.

## Reprodução e personalização

As funções auxiliares cuidam de exportação, painéis, resumos e diagnósticos. Os modelos científicos permanecem explícitos em cada seção. Para reutilizar em pesquisa, revise desenho, independência, escalas, distribuição da resposta, comparações e suporte das predições; não se limite a substituir o nome do CSV.

Os scripts usam comandos e comentários ASCII por portabilidade entre instalações do R no Windows; documentos de orientação usam português acentuado. CSV usam vírgula e ponto decimal. Os arquivos de saída são regravados dentro de `saidas/` em cada execução. O código não instala pacotes automaticamente nem apaga arquivos.

Execução validada em R 4.4.2 e ggplot2 4.0.0; o aviso de que ggplot2 foi compilado sob R 4.4.3 não impediu a execução. Valores-p abaixo da resolução do tipo double na tabela HC3 têm indicador de limite numérico e coluna `log_p` para preservar a informação; não devem ser relatados como p = 0.

## Fundamentação

- Quinn, G. P.; Keough, M. J. (2002). *Experimental Design and Data Analysis for Biologists*. Cambridge University Press. DOI: 10.1017/CBO9780511806384.
- Zuur, A. F.; Ieno, E. N.; Elphick, C. S. (2010). *A protocol for data exploration to avoid common statistical problems*. Methods in Ecology and Evolution, 1, 3–14. DOI: 10.1111/j.2041-210X.2009.00001.x.
- Wasserstein, R. L.; Lazar, N. A. (2016). *The ASA Statement on p-Values: Context, Process, and Purpose*. The American Statistician, 70, 129–133. DOI: 10.1080/00031305.2016.1154108.
- Documentação oficial do R: [anova.lm](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/anova.lm.html), [TukeyHSD](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/TukeyHSD.html), [predict.lm](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/predict.lm.html), [influence.measures](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/influence.measures.html) e [oneway.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/oneway.test.html).
