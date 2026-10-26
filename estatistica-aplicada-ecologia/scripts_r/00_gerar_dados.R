# BASES SIMULADAS PARA ENSINO; NAO SAO DADOS DE CAMPO.
# Execute na pasta principal do projeto. Semente fixa permite reproducao.
set.seed(20261026)
dir.create("dados", showWarnings = FALSE)

# 1. Comunidades de aves: 36 localidades independentes no cenario simulado.
# Uma campanha por local; quatro pontos agregados, total de quatro horas.
n <- 36
ambiente <- rep(c("Conservado", "Mosaico", "Restauracao"), each = 12)
topografia <- round(runif(n, 3, 30), 1)
chuva <- round(runif(n, 1800, 3100))
efeito <- rep(c(0.20, -0.20, 0), each = 12)
h <- 1.25 + 0.025 * topografia + 0.00020 * chuva + efeito
h <- round(h + rnorm(n, 0, 0.18), 3)
riqueza <- rpois(n, lambda = exp(2.4 + 0.0003 * (chuva - 1800)))
riqueza <- pmax(riqueza, ceiling(exp(h)) + 2)
aves <- data.frame(
  local = sprintf("L%02d", 1:n), ambiente = ambiente,
  esforco_horas = 4, grupo = "Aves", riqueza = riqueza,
  abundancia = riqueza + rpois(n, 55), diversidade_shannon = h,
  precipitacao_mm = chuva, topografia_m = topografia,
  sazonalidade_cv = round(runif(n, 20, 55), 1),
  cobertura_nativa_pct = round(runif(n, 30, 95), 1))
write.csv(aves, "dados/comunidades_amazonicas.csv", row.names = FALSE)

# H e riqueza sao respostas sinteticas, nao calculadas de uma matriz real.
# Impomos H <= log(S); nao alegamos ter estimado detectabilidade.

# 2. Igarapes: uma media de tres leituras tecnicas por igarape.
agua <- data.frame(
  igarape = sprintf("I%02d", 1:24),
  ambiente = rep(c("Conservado", "Mosaico"), each = 12),
  oxigenio_mg_l = round(c(rnorm(12, 6.6, 0.50),
                         rnorm(12, 5.6, 0.65)), 2),
  turbidez_ntu = round(rlnorm(24, log(12), 0.65), 1))
write.csv(agua, "dados/igarapes.csv", row.names = FALSE)

# 3. Pares: mesmos 12 locais em duas campanhas; dados separados.
antes <- round(rnorm(12, 5.5, 0.6), 2)
pares <- data.frame(local = sprintf("P%02d", 1:12),
  antes_mg_l = antes,
  depois_mg_l = round(antes + rnorm(12, 0.4, 0.3), 2))
write.csv(pares, "dados/agua_pareada.csv", row.names = FALSE)

# 4. DIC: 24 recipientes independentes, 8 por tratamento.
# Umidade aplicada a cada recipiente, sem compartilhar uma unica camara.
trat <- rep(c("Baixa", "Media", "Alta"), each = 8)
perda <- round(rep(c(22, 31, 38), each = 8) + rnorm(24, 0, 3.5), 2)
dic <- data.frame(recipiente = sprintf("R%02d", 1:24),
  tratamento = trat, perda_pct = perda,
  posicao = sample(1:24))
write.csv(dic, "dados/experimento_decomposicao.csv", row.names = FALSE)

# 5. DBC: seis blocos locais em gradiente topografico.
# Cada bloco contem os tres tratamentos aplicados aleatoriamente.
dbc <- expand.grid(tratamento = c("Baixa", "Media", "Alta"),
                   bloco = paste0("B", 1:6))
dbc$posicao <- unlist(lapply(1:6, function(i) sample(1:3)))
dbc$perda_pct <- round(rep(c(22, 31, 38), 6) +
  rep(c(-4, -2, 0, 1, 3, 5), each = 3) + rnorm(18, 0, 2.5), 2)
write.csv(dbc, "dados/decomposicao_blocos.csv", row.names = FALSE)
