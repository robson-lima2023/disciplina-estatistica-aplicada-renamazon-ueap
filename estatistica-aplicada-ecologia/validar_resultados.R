# Auditoria dos resultados usados no texto; nao e necessario para as aulas.
d <- read.csv("dados/comunidades_amazonicas.csv")
a <- read.csv("dados/igarapes.csv")
e <- read.csv("dados/experimento_decomposicao.csv")
b <- read.csv("dados/decomposicao_blocos.csv")
stopifnot(nrow(d) == 36, !anyDuplicated(d$local),
  all(table(d$ambiente) == 12), all(d$esforco_horas == 4),
  all(d$riqueza == floor(d$riqueza)),
  all(d$abundancia >= d$riqueza),
  all(d$diversidade_shannon >= 0),
  all(d$diversidade_shannon <= log(d$riqueza)),
  all(e$perda_pct > 0 & e$perda_pct < 100),
  all(b$perda_pct > 0 & b$perda_pct < 100),
  all(table(b$bloco, b$tratamento) == 1))
t <- t.test(a$oxigenio_mg_l[a$ambiente == "Conservado"],
            a$oxigenio_mg_l[a$ambiente == "Mosaico"])
stopifnot(abs(diff(rev(t$estimate)) - .9833333) < .00001)
m <- aov(perda_pct ~ tratamento, e)
stopifnot(abs(summary(m)[[1]][1, "F value"] - 34.18) < .01)
stopifnot(abs(sum((e$perda_pct - mean(e$perda_pct))^2) -
  sum(summary(m)[[1]][, "Sum Sq"])) < 1e-8)
reg <- lm(diversidade_shannon ~ topografia_m, d)
stopifnot(abs(coef(reg)[2] - .02601159) < 1e-7,
  abs(sqrt(mean(residuals(reg)^2)) - .2365055) < 1e-7)
cat("VALIDADO: estrutura, limites biologicos, Welch, ANOVA e regressao.\n")
