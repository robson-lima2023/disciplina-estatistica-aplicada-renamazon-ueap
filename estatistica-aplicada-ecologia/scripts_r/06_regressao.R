# UNIDADE 6 | Diversidade e topografia: associacao observacional.
library(ggplot2)
dir.create("figuras", showWarnings = FALSE)
dir.create("resultados", showWarnings = FALSE)

# 1. Exercicio 1: visualizar antes de ajustar.
dados <- read.csv("dados/comunidades_amazonicas.csv")
g <- ggplot(dados, aes(topografia_m, diversidade_shannon)) +
  geom_point(color = "#006633", size = 2) +
  geom_smooth(method = "lm", formula = y ~ x,
              color = "#004C99", fill = "#DDEAE2") +
  labs(x = "Heterogeneidade topografica (DP da elevacao, m)",
       y = "Diversidade de Shannon (log natural)") + theme_minimal()
ggsave("figuras/u6_regressao.pdf", g, width = 6.5, height = 3.6)

# 2. Exercicio 2: ajustar e interpretar a equacao.
modelo <- lm(diversidade_shannon ~ topografia_m, data = dados)
summary(modelo)
coef(modelo)
confint(modelo)
sqrt(mean(residuals(modelo)^2))  # RMSE de ajuste, divisor n.
# Coeficiente angular: variacao media de H por metro adicional de DP.
# Intercepto em topografia = 0 fica fora do intervalo observado.

# 3. Exercicio 3: diagnosticar; nenhum grafico prova independencia.
pdf("figuras/u6_diagnostico.pdf", width = 7, height = 6)
par(mfrow = c(2, 2))
plot(modelo)
dev.off()
which.max(cooks.distance(modelo))
# Investigue o local influente; nao exclua para melhorar o valor-p.

# 4. Exercicio 4: distinguir media esperada e novo local.
range(dados$topografia_m)
novo <- data.frame(topografia_m = 15)
predict(modelo, novo, interval = "confidence")
predict(modelo, novo, interval = "prediction")
# A predicao individual inclui variacao residual e e mais ampla.

# 5. Exercicio 5: ajustar por chuva e ambiente, sem selecao automatica.
dados$chuva_100mm <- (dados$precipitacao_mm - 2400) / 100
multiplo <- lm(diversidade_shannon ~ topografia_m +
                 chuva_100mm + ambiente, data = dados)
summary(multiplo)
confint(multiplo)
pdf("figuras/u6_diagnostico_multiplo.pdf", width = 7, height = 6)
par(mfrow = c(2, 2))
plot(multiplo)
dev.off()
capture.output(summary(multiplo), file = "resultados/u6_multiplo.txt")
# Coeficientes parciais mantem os demais preditores constantes.
# O ajuste nao demonstra causalidade nem remove todo confundimento.
# Riqueza e contagem: nao reutilize lm() sem avaliar sua adequacao.
