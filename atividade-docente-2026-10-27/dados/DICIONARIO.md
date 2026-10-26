# Dicionário e desenho das bases simuladas

Todos os CSV são gerados por `scripts_r/00_gerar_dados.R`, semente 20261026. Valores plausíveis não equivalem a calibração empírica regional. Não há coordenadas, campanhas ou espécies reais. As unidades são independentes **por construção didática**, não por um teste aplicado aos CSV.

## comunidades_amazonicas.csv

36 localidades de aves, 12 em cada ambiente (Conservado, Mosaico, Restauracao). Uma linha agrega quatro pontos com quatro horas de esforço total na campanha. Não há réplicas de visita.

| Coluna | Definição |
|---|---|
| local | Identificador L01 a L36 |
| ambiente | Categoria observacional da paisagem |
| esforco_horas | Esforço agregado: 4 horas/local |
| grupo | Aves, constante |
| riqueza | Número de espécies registradas |
| abundancia | Total de indivíduos registrados |
| diversidade_shannon | Resposta sintética com log natural; 0 <= H <= log(riqueza) |
| precipitacao_mm | Precipitação anual em mm |
| topografia_m | DP da elevação (m) em uma janela comum de entorno; o tamanho da janela deve ser definido em estudos reais |
| sazonalidade_cv | CV da precipitação mensal (%) |
| cobertura_nativa_pct | Porcentagem de vegetação nativa no entorno |

A simulação impõe associação de Shannon com topografia, chuva e ambiente, com ruído normal. Riqueza é contagem de Poisson ajustada para garantir coerência com H; isso a torna uma variável auxiliar sintética, não uma base para demonstrar um ajuste Poisson puro. Abundância é maior que riqueza. Cobertura e sazonalidade ampliam a discussão sem seleção automática nos modelos.

## igarapes.csv

24 igarapés independentes, 12 por ambiente (Conservado, Mosaico). `igarape` identifica a unidade. `oxigenio_mg_l` é a média de três leituras técnicas em mg/L; as leituras individuais não estão no CSV. `turbidez_ntu` expressa turbidez em NTU. Uma linha não é uma leitura técnica independente. Oxigênio tem médias/DP distintos entre grupos; turbidez é lognormal sem associação imposta com oxigênio.

## agua_pareada.csv

12 outros locais (`local`); `antes_mg_l` e `depois_mg_l` são oxigênio nas mesmas unidades em duas campanhas. Diferença: depois menos antes. Não são os igarapés da base anterior. O pareamento não implica experimento com controle.

## experimento_decomposicao.csv

24 recipientes independentes (`recipiente`), oito por `tratamento` (Baixa, Media, Alta umidade). `perda_pct`: porcentagem de perda de massa seca ao fim de um período comum. `posicao`: posição aleatoriamente atribuída entre 24 posições. A umidade é aplicada individualmente, sem câmara única por nível. Subamostras internas não aparecem como réplicas.

## decomposicao_blocos.csv

18 unidades, seis blocos locais (B1 a B6), três tratamentos por bloco. `bloco`: agrupamento local ao longo da heterogeneidade topográfica. `posicao`: posição casualizada dentro do bloco; `perda_pct`: perda de massa em %. Uma unidade por célula bloco × tratamento; modelo aditivo. Efeitos de tratamento e bloco simulados separadamente, com erro independente.
