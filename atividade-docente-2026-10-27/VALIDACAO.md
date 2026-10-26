# Registro de validação

Preparação em 26/10/2026 para a aula de 27/10/2026 (America/Fortaleza).

## Execução e dados

O script principal foi executado integralmente em sessão limpa de Rscript, sem erros. Dependências: R 4.4.2, ggplot2 4.0.0 e pacotes básicos do R, incluindo grid. Foram preservados os avisos de localidade Windows e de ggplot2 construído sob R 4.4.3; não impediram a geração dos resultados.

Os três CSV foram conferidos por SHA256 contra os arquivos da apostila: conteúdo idêntico. O script não recria os dados. A semente 20261027 controla somente jitter e realocações aleatórias da análise de randomização. As unidades, ausências, identificadores e limites biológicos são verificados antes do ajuste.

## Verificações numéricas independentes

`validar_atividade.R` passou em sessão separada. Foram conferidos:

- F da ANOVA com cálculo por SQ e QM: 34,1809, com 2 e 21 gl.
- Diferença de Tukey Alta–Baixa: 17,62375 pontos percentuais.
- Equivalência F = t² na regressão simples.
- Coeficiente parcial de topografia: 0,2686699033 por 10 m.
- F parcial de topografia calculado por redução da SQ residual e por comparação de modelos aninhados.
- Matriz HC3 implementada vetorialmente e conferida por soma independente de produtos externos por observação.
- RMSE LOO analítico conferido contra 36 reajustes explícitos que omitem uma localidade de cada vez.
- IP de novo local contendo o IC da média ao longo da grade de regressão simples.
- Ausência de p = 0 na tabela robusta; valores abaixo do limite numérico identificados e preservados na escala logarítmica.

Os comentários e o relatório HTML são produzidos com os resultados ajustados, e não preenchidos manualmente. O roteiro docente apresenta arredondamentos desses resultados.

## Saídas gráficas e relatório

Geradas 19 figuras/painéis, cada um em PNG e PDF vetorial. As 19 imagens foram inspecionadas em pranchas, com inspeção ampliada de diagnósticos, intervalos de regressão, efeitos condicionais e intervalos HC3. A composição dos quatro painéis de diagnóstico foi corrigida e novamente verificada.

O HTML contém 19 seções gráficas, 19 referências válidas a imagens locais, índice com âncoras e quatro tabelas numéricas. Não depende de servidor, internet ou instalação de Quarto. Para transferi-lo, é necessário manter a pasta `saidas/figuras/` junto ao HTML; o ZIP preserva essa estrutura. A integridade do ZIP foi conferida.

## Escopo de interpretação

Dados simulados, sem inferência regional real. Nula aguda de randomização distinguida da nula de igualdade de médias; resolução Monte Carlo explicitada. Welch é sensibilidade, não pré-teste seletor. HC3 usa referência normal assintótica e não corrige dependência. Modelos múltiplos e interação não passam por seleção automática; LOO é avaliação interna. DBC é uma base experimental separada e não uma comparação controlada de eficiência com o DIC.

Fontes metodológicas e links oficiais estão no README e no relatório. Nenhum arquivo da apostila ou do repositório publicado foi modificado por esta atividade.
