# UNIDADE 3 | Diferencas, intervalos e incerteza.
library(ggplot2)
dir.create("resultados", showWarnings = FALSE)
dir.create("figuras", showWarnings = FALSE)

# 1. Exercicio 1: hipoteses definidas antes da analise.
# H0: media de oxigenio igual nos dois ambientes.
# H1 bilateral: medias diferentes; alpha = 0.05.
agua <- read.csv("dados/igarapes.csv")
x <- agua$oxigenio_mg_l[agua$ambiente == "Conservado"]
y <- agua$oxigenio_mg_l[agua$ambiente == "Mosaico"]

# 2. Exercicio 2: calcular diferenca e teste t de Welch.
mean(x) - mean(y)  # Direcao: Conservado menos Mosaico.
teste <- t.test(x, y, conf.level = .95)
print(teste)
teste$conf.int
# O intervalo e da diferenca, em mg/L; nao da media de cada grupo.
# Welch permite variancias distintas; nao resolve dependencia.

# 3. Exercicio 3: diagnostico, sem escolher teste por um unico p.
pdf("figuras/u3_qq.pdf", width = 7, height = 3.5)
par(mfrow = c(1, 2))
qqnorm(x, main = "Conservado"); qqline(x)
qqnorm(y, main = "Mosaico"); qqline(y)
dev.off()
shapiro.test(x)
shapiro.test(y)
# p > .05 nao prova normalidade, sobretudo com n pequeno.

# 4. Exercicio 4: mesmos locais antes e depois (pares na mesma linha).
pares <- read.csv("dados/agua_pareada.csv")
delta <- pares$depois_mg_l - pares$antes_mg_l
mean(delta)
t.test(pares$depois_mg_l, pares$antes_mg_l, paired = TRUE)
# A normalidade relevante e a das diferencas entre campanhas.
shapiro.test(delta)
# Sem grupo-controle, mudanca temporal nao prova efeito de intervencao.

# 5. Exercicio 5: planejar poder para efeito definido previamente.
plano <- power.t.test(delta = .7, sd = .6, sig.level = .05,
                      power = .80, type = "two.sample")
print(plano)
ceiling(plano$n)  # 13 unidades independentes por grupo, sem perdas.
# n e por grupo; arredonde para cima e considere perdas e dependencia.
# O calculo supoe variancias iguais, ao contrario do Welch acima.
capture.output(teste, file = "resultados/u3_welch.txt")
