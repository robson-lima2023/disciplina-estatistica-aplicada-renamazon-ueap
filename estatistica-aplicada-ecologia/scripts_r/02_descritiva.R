# UNIDADE 2 | Resumo numerico e visual dos dados.
library(ggplot2)
dir.create("figuras", showWarnings = FALSE)

# 1. Exercicio 1: nutrientes (mg/L), exemplo numerico pequeno.
x <- c(1, 2, 2, 3, 12)
mean(x)
median(x)
table(x)  # A moda e 2; mode() em R nao calcula a moda estatistica.
weighted.mean(c(2, 4), w = c(3, 1))  # Media ponderada: 2.5.

# 2. Exercicio 2: dispersao e separatrizes.
var(x)
sd(x)
sd(x) / sqrt(length(x))  # EP: incerteza da media sob independencia.
diff(range(x))
IQR(x, type = 7)
quantile(x, probs = c(.25, .50, .75, .90), type = 7)
100 * sd(x) / mean(x)  # CV: escala de razao, media positiva.
# DP descreve observacoes; EP descreve a precisao da media.

# 3. Exercicio 3: resumo dos igarapes, sem eliminar dados silenciosamente.
agua <- read.csv("dados/igarapes.csv")
colSums(is.na(agua))
aggregate(oxigenio_mg_l ~ ambiente, data = agua, FUN = mean)
aggregate(oxigenio_mg_l ~ ambiente, data = agua, FUN = sd)
quantile(agua$turbidez_ntu, probs = seq(.1, .9, .1), type = 7)

# 4. Exercicio 4: construir e salvar quatro graficos.
theme_set(theme_minimal(base_size = 12))
g1 <- ggplot(agua, aes(turbidez_ntu)) +
  geom_histogram(bins = 8, fill = "#006633", color = "white") +
  labs(x = "Turbidez (NTU)", y = "Numero de igarapes")
g2 <- ggplot(agua, aes(ambiente, oxigenio_mg_l)) +
  geom_boxplot(fill = "#DDEAE2", outlier.shape = NA) +
  geom_point(position = position_jitter(width = .08, seed = 1)) +
  labs(x = "Ambiente", y = "Oxigenio dissolvido (mg/L)")
g3 <- ggplot(agua, aes(turbidez_ntu)) +
  geom_density(fill = "#DDEAE2") +
  labs(x = "Turbidez (NTU)", y = "Densidade")
g4 <- ggplot(agua, aes(turbidez_ntu, oxigenio_mg_l)) +
  geom_point(color = "#004C99", size = 2) +
  labs(x = "Turbidez (NTU)", y = "Oxigenio (mg/L)")
ggsave("figuras/u2_histograma.pdf", g1, width = 6, height = 3.2)
ggsave("figuras/u2_boxplot.pdf", g2, width = 6, height = 3.2)
ggsave("figuras/u2_densidade.pdf", g3, width = 6, height = 3.2)
ggsave("figuras/u2_dispersao.pdf", g4, width = 6, height = 3.2)
# Densidade depende da suavizacao; boxplot nao testa hipoteses.
# Um ponto extremo deve ser investigado, nao apagado automaticamente.
