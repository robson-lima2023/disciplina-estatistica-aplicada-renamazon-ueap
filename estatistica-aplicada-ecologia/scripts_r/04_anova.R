# UNIDADE 4 | DIC e DBC: o delineamento determina o modelo.
dir.create("figuras", showWarnings = FALSE)
dir.create("resultados", showWarnings = FALSE)

# 1. Exercicio 1: ler o DIC e conferir oito recipientes por grupo.
dic <- read.csv("dados/experimento_decomposicao.csv")
dic$tratamento <- factor(dic$tratamento,
                         levels = c("Baixa", "Media", "Alta"))
table(dic$tratamento)
modelo <- aov(perda_pct ~ tratamento, data = dic)
summary(modelo)

# 2. Exercicio 2: conferir a decomposicao da soma de quadrados.
media_geral <- mean(dic$perda_pct)
sq_total <- sum((dic$perda_pct - media_geral)^2)
sq_residuo <- sum(residuals(modelo)^2)
sq_tratamento <- sq_total - sq_residuo
f_manual <- (sq_tratamento / 2) / (sq_residuo / 21)
c(SQ_total = sq_total, SQ_tratamento = sq_tratamento,
  SQ_residuo = sq_residuo, F = f_manual)
# Total: 23 gl; tratamento: 2; residuo: 21.

# 3. Exercicio 3: diagnosticar o modelo e a ordem espacial.
pdf("figuras/u4_diagnostico.pdf", width = 7, height = 6)
par(mfrow = c(2, 2))
plot(modelo)
dev.off()
fligner.test(perda_pct ~ tratamento, data = dic)
plot(dic$posicao, residuals(modelo),
     xlab = "Posicao casualizada", ylab = "Residuo")
abline(h = 0, lty = 2)
# Fligner e auxiliar; independencia vem do protocolo, nao deste teste.
# Em variancias muito distintas: discutir ANOVA de Welch e o desenho.

# 4. Exercicio 4: DBC completo com seis blocos e tres tratamentos.
dbc <- read.csv("dados/decomposicao_blocos.csv")
dbc$bloco <- factor(dbc$bloco)
dbc$tratamento <- factor(dbc$tratamento,
                         levels = c("Baixa", "Media", "Alta"))
table(dbc$bloco, dbc$tratamento)
modelo_blocos <- aov(perda_pct ~ bloco + tratamento, data = dbc)
summary(modelo_blocos)
# Sem replica em cada celula, nao estimamos interacao bloco:tratamento.
# Modelo aditivo: 5 gl de bloco, 2 de tratamento, 10 de residuo.
capture.output(summary(modelo), file = "resultados/u4_dic.txt")
capture.output(summary(modelo_blocos), file = "resultados/u4_dbc.txt")

