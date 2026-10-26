# UNIDADE 5 | Comparacoes com controle de multiplicidade.
library(ggplot2)
dir.create("figuras", showWarnings = FALSE)
dir.create("resultados", showWarnings = FALSE)

# 1. Exercicio 1: ajustar o mesmo DIC da unidade anterior.
dados <- read.csv("dados/experimento_decomposicao.csv")
dados$tratamento <- factor(dados$tratamento,
                           levels = c("Baixa", "Media", "Alta"))
modelo <- aov(perda_pct ~ tratamento, data = dados)
summary(modelo)

# 2. Exercicio 2: Tukey para todas as tres diferencas.
tukey <- TukeyHSD(modelo, "tratamento", conf.level = .95)
print(tukey)
write.csv(tukey$tratamento, "resultados/u5_tukey.csv")
# diff: segunda media menos primeira na etiqueta exibida.
# lwr e upr: IC simultaneo; p adj: valor-p ajustado.

# 3. Exercicio 3: medias e IC individuais sob o modelo comum.
medias <- aggregate(perda_pct ~ tratamento, dados, mean)
qm_res <- deviance(modelo) / df.residual(modelo)
ep <- sqrt(qm_res / 8)
margem <- qt(.975, df.residual(modelo)) * ep
medias$inferior <- medias$perda_pct - margem
medias$superior <- medias$perda_pct + margem
g <- ggplot(medias, aes(tratamento, perda_pct)) +
  geom_errorbar(aes(ymin = inferior, ymax = superior), width = .12) +
  geom_point(size = 3, color = "#006633") +
  labs(x = "Umidade", y = "Perda de massa (%)") + theme_minimal()
ggsave("figuras/u5_medias.pdf", g, width = 6, height = 3.4)
# Estes IC sao individuais; o teste de Tukey usa IC das diferencas.
# Sobreposicao de IC individuais nao substitui o teste das diferencas.

# 4. Exercicio 4: contraste planejado Alta menos Baixa.
estimativa <- medias$perda_pct[3] - medias$perda_pct[1]
ep_contraste <- sqrt(qm_res * (1/8 + 1/8))
t_obs <- estimativa / ep_contraste
p_contraste <- 2 * pt(-abs(t_obs), df.residual(modelo))
c(diferenca = estimativa, EP = ep_contraste, p = p_contraste)
# Valido como uma unica pergunta planejada ANTES de ver os dados.
# Se ha uma familia de contrastes, planeje o ajuste dessa familia.
# Avalie tambem se a diferenca supera um limiar ecologico justificado.
