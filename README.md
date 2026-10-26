# disciplina-estatistica-aplicada-renamazon-ueap
Materiais da disciplina Estatística Aplicada no RENAMAZON/UEAP: aulas, apostilas, scripts em R e dados ecológicos.

## Atividade prática — ANOVA, teste F, Tukey e regressão

**Aula de 27 de outubro de 2026 · Caderno institucional e oficina docente em R**

Caderno de **47 páginas**, com fundamentos, roteiro de discussão, perguntas e respostas esperadas, **19 figuras/painéis comentados** e o **script integral de 722 linhas**, organizado em blocos com numeração contínua. A atividade explora decomposição de serapilheira e diversidade de aves, utilizando as bases simuladas da apostila.

- [Ler o caderno de aula em PDF](atividade-docente-2026-10-27/output/pdf/Caderno_Atividade_ANOVA_Tukey_Regressao.pdf)
- [Baixar o pacote atualizado completo — PDF, LaTeX, R, dados e figuras](Caderno_Atividade_ANOVA_Tukey_Regressao_LaTeX.zip)
- [Abrir o script principal em R](atividade-docente-2026-10-27/atividade_docente.R)
- [Consultar o roteiro docente e as respostas esperadas](atividade-docente-2026-10-27/ROTEIRO_DOCENTE.md)
- [Acessar os dados CSV da atividade](atividade-docente-2026-10-27/dados)
- [Consultar os gráficos em PNG e PDF](atividade-docente-2026-10-27/saidas/figuras)
- [Consultar as tabelas de resultados](atividade-docente-2026-10-27/saidas/tabelas)
- [Acessar o relatório HTML — baixe o pacote para abrir localmente](atividade-docente-2026-10-27/saidas/relatorio_aula.html)
- [Consultar os fontes LaTeX e as instruções de compilação](atividade-docente-2026-10-27/caderno_latex/README.md)
- [Consultar as instruções de execução e a fundamentação](atividade-docente-2026-10-27/README.md)
- [Consultar a validação numérica e gráfica](atividade-docente-2026-10-27/VALIDACAO.md)
- [Baixar o pacote original da oficina em R, anterior ao caderno LaTeX](atividade_docente_ANOVA_Tukey_Regressao_27-10-2026.zip)

Para executar, extraia o pacote atualizado, abra `atividade-docente.Rproj` no RStudio, instale `ggplot2` se necessário e execute `atividade_docente.R`. O relatório HTML funciona localmente, sem internet, desde que a pasta de figuras permaneça junto dele. Os arquivos LaTeX também devem permanecer na estrutura do pacote para localizar o script e as figuras.

Além da análise exploratória, ANOVA e Tukey, o script inclui regressão simples e múltipla, testes F parciais, diagnósticos, intervalos de confiança e predição e extensões de randomização, HC3, influência, leave-one-out e blocos casualizados. **Todos os dados são simulados para ensino.**

## Apostila de Estatística Aplicada

**Estatística Aplicada à Ecologia, Biodiversidade e Recursos Naturais Amazônicos**  
Prof. Dr. Robson Borges de Lima · UEAP · edição 2026

Material no template institucional, com 42 páginas, sete unidades, 31 exercícios, gabarito e scripts completos em R ao final de cada unidade. Os exemplos abrangem diversidade de aves, clima e topografia, qualidade da água e decomposição de serapilheira.

- [Ler a apostila em PDF](estatistica-aplicada-ecologia/apostila_estatistica_aplicada.pdf)
- [Baixar o projeto completo em ZIP](apostila_estatistica_recursos_naturais_amazonicos.zip)
- [Acessar os scripts em R](estatistica-aplicada-ecologia/scripts_r)
- [Acessar os dados CSV](estatistica-aplicada-ecologia/dados)
- [Consultar o dicionário dos dados](estatistica-aplicada-ecologia/dados/DICIONARIO.md)
- [Consultar fontes LaTeX e instruções de reprodução](estatistica-aplicada-ecologia/README.md)
- [Consultar o registro de validação](estatistica-aplicada-ecologia/VALIDACAO.md)

**Todos os dados são simulados para ensino**, com semente fixa. Não representam observações de campo ou estimativas reais sobre a Amazônia.

### Reproduzir as análises

1. Baixe e extraia o ZIP ou clone o repositório.
2. Abra `estatistica-aplicada-ecologia/estatistica-aplicada-ecologia.Rproj` no RStudio.
3. Instale a dependência: `install.packages("ggplot2")`.
4. Execute os scripts por unidade ou, na pasta do projeto, `source("executar_tudo.R", encoding = "UTF-8")`.

Os arquivos CSV já estão incluídos. Os scripts utilizam principalmente R básico, com comentários em português e orientações de interpretação. O projeto também contém gráficos vetoriais, referências bibliográficas e instruções para compilar a apostila em LaTeX.
