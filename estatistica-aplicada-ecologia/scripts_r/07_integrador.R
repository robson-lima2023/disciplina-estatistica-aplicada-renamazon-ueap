# UNIDADE 7 | Um fluxo completo para uma pergunta delimitada.
library(ggplot2)
dir.create("figuras", showWarnings = FALSE)
dir.create("resultados", showWarnings = FALSE)

# 1. Exercicio 1: auditar dados e descrever amostragem.
d <- read.csv("dados/comunidades_amazonicas.csv")
d$ambiente <- factor(d$ambiente,
                     levels = c("Conservado", "Mosaico", "Restauracao"))
stopifnot(!anyDuplicated(d$local), all(d$esforco_horas == 4))
colSums(is.na(d))
table(d$ambiente)
# Uma linha = uma localidade. Esforco igual nao garante deteccao igual.

# 2. Exercicio 2: descrever H por ambiente.
aggregate(diversidade_shannon ~ ambiente, d, mean)
aggregate(diversidade_shannon ~ ambiente, d, sd)
aggregate(diversidade_shannon ~ ambiente, d,
          function(x) quantile(x, c(.25, .50, .75)))
g <- ggplot(d, aes(ambiente, diversidade_shannon)) +
  geom_boxplot(fill = "#DDEAE2", outlier.shape = NA) +
  geom_point(position = position_jitter(width = .08, seed = 2)) +
  labs(x = "Ambiente", y = "Diversidade de Shannon") + theme_minimal()
ggsave("figuras/u7_ambientes.pdf", g, width = 6.5, height = 3.6)

# 3. Exercicio 3: ANOVA e Tukey, comparacao observacional nao ajustada.
comparacao <- aov(diversidade_shannon ~ ambiente, data = d)
summary(comparacao)
TukeyHSD(comparacao, "ambiente")
# Esta ANOVA testa medias entre ambientes observados; nao efeito causal.
# Antes de confiar: diagnosticos e desenho, como na unidade 4.
pdf("figuras/u7_diagnostico.pdf", width = 7, height = 6)
par(mfrow = c(2, 2))
plot(comparacao)
dev.off()

# 4. Exercicio 4: relacao com topografia, chuva e ambiente.
d$chuva_100mm <- (d$precipitacao_mm - 2400) / 100
ajuste <- lm(diversidade_shannon ~ topografia_m +
               chuva_100mm + ambiente, data = d)
summary(ajuste)
confint(ajuste)
pdf("figuras/u7_diagnostico_ajustado.pdf", width = 7, height = 6)
par(mfrow = c(2, 2))
plot(ajuste)
dev.off()
capture.output(summary(ajuste), file = "resultados/u7_modelo.txt")

# 5. Exercicio 5: produzir texto com estimativa e IC reais.
b <- coef(ajuste)["topografia_m"]
ic <- confint(ajuste)["topografia_m", ]
texto <- sprintf(paste("Em 36 localidades simuladas, a associacao parcial",
  "entre topografia e Shannon foi %.3f por metro (IC95%% %.3f a %.3f),",
  "ajustada por chuva e ambiente. O desenho e observacional;",
  "a analise nao estabelece causalidade."), b, ic[1], ic[2])
cat(texto, "\n")
writeLines(texto, "resultados/u7_redacao.txt")
# Para a dissertacao: substituir dados, revisar desenho e diagnosticos,
# justificar preditores e relatar limitacoes antes de interpretar.
