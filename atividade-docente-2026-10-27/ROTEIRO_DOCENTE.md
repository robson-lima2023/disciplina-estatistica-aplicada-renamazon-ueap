# Roteiro para condução da atividade

**27 de outubro de 2026 · Estatística Aplicada · RENAmazon/UEAP**

## Objetivo da aula

Mostrar como uma pergunta ecológica se transforma em análise auditável: explorar dados, representar variabilidade e incerteza, formular hipóteses, examinar modelos e interpretar estimativas. O eixo conceitual é a comparação entre variação explicada e residual, que conecta ANOVA e regressão.

O script foi desenvolvido para o professor. As funções de infraestrutura podem ser carregadas previamente; durante a aula, priorize os dados, as fórmulas dos modelos, os gráficos e as interpretações. Reserve a implementação matricial HC3 e as rotinas leave-one-out para discussão avançada, se houver tempo.

## Percurso sugerido — 180 minutos, adaptável

| Tempo | Condução | Seções e figuras |
|---|---|---|
| 0–15 min | Perguntas, desenho, unidade e auditoria | Seção 1 |
| 15–35 min | Exploração: antecipar diferenças sem calcular p | Seção 2; figuras 01 e 02 |
| 35–65 min | Construir SQ, QM e F; visualizar a hipótese nula | Seção 3; figuras 03 e 04 |
| 65–80 min | Confrontar pressupostos com dados e protocolo | Seção 4; figuras 05 e 06 |
| 80–105 min | Comparações de Tukey e magnitude | Seção 6; figuras 08 e 09 |
| 105–135 min | Regressão simples, F = t² e dois intervalos | Seções 7–8; figuras 10–13 |
| 135–165 min | Regressão múltipla e teste F parcial | Seções 9–10; figuras 14–16 |
| 165–180 min | Redação do resultado e síntese | Seção 13 |

**Extensões:** randomização (seção 5), interação/HC3 (parte da seção 10), sensibilidade/LOO (seção 11) e DBC (seção 12). Para uma aula de 120 minutos, concentre-se no DIC, Tukey e regressão simples, deixando regressão múltipla e extensões para outra sessão.

## Antes de iniciar

- Abra o `.Rproj` e carregue a seção 0, que define as funções e o padrão gráfico.
- Deixe `saidas/relatorio_aula.html` aberto como apoio à projeção; todas as figuras já estão disponíveis.
- Apresente o caráter simulado dos dados antes de mostrar resultados. As médias e efeitos não descrevem a Amazônia real.
- Diferencie o DIC de decomposição, em que o tratamento foi alocado às unidades, do estudo de aves, em que os ambientes são categorias observadas.

## Atividade 1 — Ler os dados como um pesquisador

**Pergunta:** o que cada linha representa? Quais observações poderiam ser réplicas e quais seriam subamostras?

**Execução:** seção 1; examine `str()`, contagens por grupo e resumos.

**Resposta esperada:** 24 recipientes no DIC, oito por umidade; 36 localidades de aves, 12 por ambiente; 18 unidades no DBC. Os quatro pontos de escuta agregados não fornecem quatro réplicas independentes do ambiente. Se uma única câmara recebesse cada nível de umidade, o efeito de câmara ficaria confundido com tratamento.

**Ênfase oral:** independência é uma propriedade do desenho e do processo, não um resultado de Shapiro. O número de linhas não define sozinho o tamanho amostral efetivo.

## Atividade 2 — Antecipar padrões com exploração gráfica

**Pergunta:** qual grupo parece ter maior perda de massa? A dispersão é comparável? Os grupos são totalmente separados?

**Execução:** seção 2; figuras 01 e 02.

**Valores de referência:** médias de 21,683%, 29,458% e 39,306% para Baixa, Média e Alta; DP de 4,402, 4,696 e 3,652 pontos percentuais.

**Resposta esperada:** gradiente de médias com sobreposição de observações individuais. A sobreposição não impede diferenças entre médias; a posição de um único recipiente não representa a média de um tratamento. Com oito observações por grupo, a forma do histograma é instável; pontos brutos são essenciais.

**Recurso gráfico a demonstrar:** alterar `binwidth`, a transparência e a largura do jitter. Manter a mesma escala permite comparar dispersão; mudar escalas pode esconder diferenças. O jitter altera apenas a posição horizontal de exibição, sem mudar os dados analisados.

## Atividade 3 — Construir o teste F sem tratá-lo como caixa-preta

**Hipóteses:** H0: μBaixa = μMédia = μAlta. H1: pelo menos uma média difere. α = 0,05, definido antes da análise.

**Execução:** seção 3; compare os segmentos da figura 03 e a distribuição da figura 04.

**Questões para a turma:**

1. Por que centralizar todas as observações na média geral produz mais variação que centralizá-las nas médias dos tratamentos?
2. Por que dividir as somas de quadrados por graus de liberdade antes de formar a razão?
3. Se H0 fosse verdadeira, o que esperar da razão QMtratamento/QMerro?
4. O F global informa qual par difere?

**Referências numéricas:** F(2,21) = 34,181; F crítico ≈ 3,467; p ≈ 2,49 × 10⁻⁷; eta² ≈ 0,765; omega² ≈ 0,734.

**Interpretação:** existe evidência contra a igualdade das três médias sob o modelo e o desenho. F alto expressa grande separação relativa à variabilidade residual, mas não substitui magnitude na escala da resposta. Eta² não significa que esse tratamento explicará a mesma fração da variação em todos os ambientes reais.

**Frase a corrigir em aula:** “A chance de H0 ser verdadeira é 0,000000249.” O valor-p é calculado sob a nula e as demais suposições; não é probabilidade posterior da hipótese.

## Atividade 4 — Diagnosticar antes de concluir

**Execução:** seção 4; figuras 05 e 06.

**Perguntas:** o Q–Q tem desvios sistemáticos? Há dispersão residual claramente distinta? Há posição experimental associada ao resíduo? O que esses gráficos não conseguem testar?

**Condução:** explique os quatro painéis e os resultados de Shapiro e Fligner como informações complementares. Não use “p > 0,05” para certificar pressupostos. No DIC balanceado, as alavancagens são iguais; diferenças de Cook decorrem dos resíduos, e não de posições extremas de preditores contínuos.

**Sensibilidade:** Welch retorna F aproximado ≈ 37,129 e p ≈ 2,75 × 10⁻⁶. As duas análises apontam evidência contra igualdade de médias, mas o professor não escolhe retrospectivamente o teste com menor p. Se a heterocedasticidade fosse relevante, Tukey clássico também precisaria ser revisto; trocar apenas o F não conserta toda a análise.

## Atividade 5 — Ler Tukey como diferenças, não como letras

**Execução:** seção 6; figuras 08 e 09.

| Diferença | Estimativa, p.p. | IC95% simultâneo |
|---|---:|---:|
| Média − Baixa | 7,775 | 2,390 a 13,160 |
| Alta − Baixa | 17,624 | 12,239 a 23,009 |
| Alta − Média | 9,849 | 4,464 a 15,234 |

**Perguntas:**

1. O que define o sinal de cada diferença?
2. O intervalo cobre zero? Qual é a magnitude compatível com os dados?
3. Por que o intervalo de uma média não substitui o intervalo da diferença?
4. A diferença entre 39,306% e 21,683% é de 17,624% ou 17,624 pontos percentuais?

**Resposta esperada:** todos os pares apresentam IC que excluem zero. O maior contraste é Alta − Baixa, com maior perda na umidade alta. A unidade é ponto percentual. Aumento relativo seria outro cálculo, com divisão por uma referência.

**Ênfase:** o procedimento controla a família dos três pares. Não apresentar uma não rejeição como equivalência. Não usar significância como medida de importância ecológica. Perda de massa é um indicador de decomposição; não mede, sozinha, toda a ciclagem de nutrientes.

**Recurso gráfico:** compare o forest plot de diferenças com os pontos brutos e as médias. Evite letras na primeira demonstração para manter a atenção em estimativa, incerteza e unidade.

## Atividade 6 — Conectar ANOVA e regressão

**Execução:** seções 7 e 8; figuras 10–13.

**Hipótese:** H0: βtopografia = 0. A alternativa bilateral admite inclinação diferente de zero.

**Referências:** Ĥ = 1,77292 + 0,02601 × topografia em metros; F(1,34) ≈ 20,104; R² ≈ 0,372. O F é numericamente igual ao quadrado do t da inclinação, porque há um único coeficiente angular testado sob o mesmo modelo.

**Perguntas:** a inclinação tem qual unidade? O intercepto em 0 m é ecologicamente interpretável? A topografia causa a diversidade? Uma nova localidade estará na faixa azul ou na faixa cinza?

**Resposta esperada:** Shannon por metro de DP da elevação. O zero fica fora do intervalo observado (4,4 a 30 m), limitando a interpretação do intercepto. O estudo é observacional. A faixa azul é IC da média; a cinza é IP de uma nova observação, mais amplo por incorporar o erro residual individual.

**Comentário de diagnóstico:** o local L04 tem a maior distância de Cook no modelo simples. Investigue o contexto e a estrutura entre ambientes. Não exclua o local para melhorar a significância. Uma observação influente pode revelar uma variável explicativa omitida, não um erro de campo.

## Atividade 7 — Separar associação simples de associação parcial

**Execução:** seções 9 e 10; figuras 14–16.

O modelo usa topografia centrada em 15 m e expressa por 10 m; chuva centrada em 2400 mm e expressa por 100 mm; Conservado é a referência do fator ambiente. O intercepto deixa de se referir a topografia e chuva iguais a zero, mas continua condicionado à categoria de referência e ao suporte dos dados.

**Hipótese parcial:** βtopografia = 0 depois de incluir chuva e ambiente. Compare o modelo sem topografia com o modelo completo sobre as mesmas 36 linhas.

**Resultados:** coeficiente de 0,26867 Shannon por 10 m, IC95% 0,18384 a 0,35350; F parcial(1,31) ≈ 41,721, p ≈ 3,35 × 10⁻⁷. Ambiente é testado conjuntamente com dois gl: F(2,31) ≈ 21,363, p ≈ 1,47 × 10⁻⁶.

**Ênfase:** `anova(um_modelo)` produz uma decomposição sequencial. A ordem dos termos pode importar. `anova(reduzido, completo)` explicita a pergunta parcial, desde que os modelos sejam aninhados, sobre as mesmas observações e com a estrutura residual apropriada. O teste do fator inteiro não é o teste de apenas um dos seus coeficientes.

**Leitura do gráfico condicional:** linhas são médias previstas com chuva fixada em 2400 mm; os pontos tiveram apenas o termo de chuva removido. As linhas ficam dentro da faixa de topografia observada em cada ambiente. As inclinações são iguais por construção do modelo aditivo; não são três inclinações estimadas separadamente.

**Extensão de interação:** adicionar topografia × ambiente produz F ≈ 1,770 e p ≈ 0,188. Isso não demonstra identidade das inclinações. Trata-se de uma extensão exploratória identificada, e não de justificativa para selecionar automaticamente a história ecológica pelo p.

**HC3:** compare os IC robustos e clássicos. Os coeficientes não mudam, mas a estimativa da covariância muda. HC3 com referência normal é assintótico e não equivale a corrigir dependência espacial. Para topografia, o IC robusto é aproximadamente 0,176 a 0,362 por 10 m.

## Atividade 8 — Explicar o que “modelo melhor” significa

**Execução:** seção 11; figura 17.

| Modelo | R² ajustado | RMSE de ajuste | RMSE LOO |
|---|---:|---:|---:|
| Simples | 0,353 | 0,237 | 0,249 |
| Múltiplo | 0,714 | 0,150 | 0,175 |

O erro de ajuste usa as observações que estimaram os coeficientes; LOO omite cada local antes de prever sua resposta. Ainda é uma avaliação interna ao conjunto simulado, não validação regional independente. Para dados espaciais ou temporais dependentes, a separação de treino e avaliação precisa refletir essa dependência.

A inclinação parcial, ao omitir um local por vez, varia aproximadamente de 0,246 a 0,293 por 10 m. A figura mostra sensibilidade, não um ranking de locais a excluir. Discuta também se as métricas respondem à pergunta principal: explicação de associação e previsão são objetivos relacionados, mas diferentes.

## Extensão experimental — DBC

**Execução:** seção 12; figuras 18 e 19.

Há seis blocos completos e uma unidade por tratamento em cada bloco. F de tratamento ajustado para bloco ≈ 105,428, com 2 e 10 gl. As linhas do perfil conectam unidades diferentes do mesmo bloco; não representam medidas repetidas no tempo nem uma dose quantitativa contínua.

Sem réplicas dentro da célula bloco × tratamento, a interação não é separada do erro. O DBC e o DIC têm bases de experimentos diferentes: não compare seus quadrados médios como demonstração controlada da eficiência do bloqueamento.

## Extensão conceitual — randomização

**Execução:** seção 5; figura 07.

Das 4999 realocações, nenhuma atingiu o F observado. O p Monte Carlo corrigido é 1/5000 = 0,0002; não é zero e não resolve uma cauda da ordem de 10⁻⁷. A nula aguda afirma ausência de efeito em cada unidade; não é apenas igualdade das médias. A permutação livre de rótulos é justificada aqui pelo DIC completamente casualizado, não pelo fato de o comando `sample()` estar disponível.

## Fechamento — produto da turma

Peça uma síntese de até oito linhas que inclua: desenho e unidade; hipótese; diferença Alta − Baixa com IC simultâneo; associação parcial de topografia com IC; uma observação de diagnóstico; e uma limitação de inferência. Não aceite uma conclusão formada somente por valores-p.

O arquivo `saidas/comentarios_resultados.txt` contém uma síntese calculada pelo script. Use-o como referência para discutir uma boa redação; não como texto a copiar para qualquer dissertação. Dados simulados demonstram o procedimento, e não resultados de campo.
