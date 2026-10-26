# ============================================================================
# ESTATISTICA APLICADA A ECOLOGIA | RENAmazon / UEAP
# Oficina docente: ANOVA, teste F, Tukey e regressao
# Prof. Dr. Robson Borges de Lima | Aula sugerida: 27/10/2026
# ============================================================================
# FINALIDADE
# Conduzir uma demonstracao cientificamente fundamentada e graficamente rica.
# Os dados foram simulados para a apostila; nao sao observacoes de campo.
# Este arquivo NAO simula novos dados e NAO modifica os CSV distribuidos.
#
# EXECUCAO: abra o .Rproj desta pasta e execute o arquivo inteiro ou por secoes.
# Dependencia externa unica: install.packages("ggplot2")
# Saidas: figuras PNG/PDF, tabelas CSV, relatorio HTML, comentarios e sessao.
#
# PERGUNTAS
# A. A umidade afeta a perda media de massa no experimento de decomposicao?
# B. Quais diferencas entre tratamentos sao sustentadas pelos intervalos?
# C. Como Shannon se associa a topografia, chuva e ambiente entre locais?
# D. Como a inferencia muda ao incorporar estrutura, incerteza e diagnosticos?
#
# REFERENCIAS METODOLOGICAS
# Quinn & Keough (2002), Experimental Design and Data Analysis for Biologists.
# Zuur, Ieno & Elphick (2010), doi:10.1111/j.2041-210X.2009.00001.x.
# Wasserstein & Lazar (2016), doi:10.1080/00031305.2016.1154108.
# Documentacao oficial R: anova.lm, TukeyHSD, predict.lm, influence.measures.
# As formulas sao explicitadas abaixo; decisoes nao sao automatizadas por p.

# 0. CONFIGURACAO E FUNCOES DE APOIO ------------------------------------------
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop("Instale ggplot2 antes da aula: install.packages('ggplot2')")
}
library(ggplot2)
if (!file.exists("dados/experimento_decomposicao.csv")) {
  stop("Abra atividade-docente.Rproj ou execute a partir da pasta da atividade.")
}
alpha <- 0.05
semente <- 20261027
B <- 4999L                    # Numero de realocacoes do teste de randomizacao.
exibir_graficos <- interactive()
dir.create("saidas", showWarnings = FALSE)
dir.create("saidas/figuras", showWarnings = FALSE)
dir.create("saidas/tabelas", showWarnings = FALSE)
cores <- c(Baixa = "#0072B2", Media = "#E69F00", Alta = "#009E73",
           Conservado = "#006633", Mosaico = "#CC6677",
           Restauracao = "#4477AA")
theme_set(theme_minimal(base_size = 13, base_family = "sans") +
  theme(plot.title = element_text(face = "bold", color = "#002D5A"),
        plot.subtitle = element_text(size = 10.5),
        plot.caption = element_text(size = 9, hjust = 0),
        panel.grid.minor = element_blank(), legend.position = "bottom"))
options(width = 110, digits = 6)
galeria <- list()
comentarios <- character()

# Comentarios sao simultaneamente impressos e guardados, usando valores reais.
comentar <- function(...) {
  texto <- paste0(...)
  comentarios <<- c(comentarios, texto)
  cat("\n", texto, "\n", sep = "")
}
fmt <- function(x, casas = 3) formatC(x, format = "f", digits = casas)
fp <- function(x) format.pval(x, digits = 3, eps = 1e-12)
exportar <- function(x, nome) {
  write.csv(x, file.path("saidas/tabelas", paste0(nome, ".csv")),
            row.names = FALSE, fileEncoding = "UTF-8")
  print(x)
  invisible(x)
}
salvar <- function(grafico, nome, titulo, largura = 9, altura = 5.5) {
  for (ext in c("png", "pdf")) {
    ggsave(file.path("saidas/figuras", paste0(nome, ".", ext)),
      plot = grafico, width = largura, height = altura,
      units = "in", dpi = 180, bg = "white", limitsize = TRUE)
  }
  galeria[[nome]] <<- list(titulo = titulo, grafico = grafico)
  if (exibir_graficos) {
    if (inherits(grafico, "ggplot")) print(grafico) else {
      grid::grid.newpage(); grid::grid.draw(grafico)
    }
  }
  invisible(grafico)
}

# Painel com grid: dispensa pacotes adicionais para compor figuras.
painel <- function(graficos, ncol = 2) {
  ng <- length(graficos)
  grobs <- lapply(seq_along(graficos), function(i) {
    g <- ggplotGrob(graficos[[i]])
    g$name <- paste0("subpainel_", i)
    g$vp <- grid::viewport(layout.pos.row = ceiling(i / ncol),
                          layout.pos.col = (i - 1) %% ncol + 1)
    g
  })
  grid::grobTree(children = do.call(grid::gList, grobs),
    vp = grid::viewport(layout = grid::grid.layout(ceiling(ng / ncol), ncol)))
}

# Resumo por grupos: IC individuais para descricao, nao simultaneos de Tukey.
resumir <- function(dados, resposta, grupo) {
  partes <- split(dados[[resposta]], dados[[grupo]], drop = TRUE)
  z <- lapply(names(partes), function(nome) {
    x <- partes[[nome]]
    n <- length(x); s <- sd(x); ep <- s / sqrt(n)
    data.frame(grupo = nome, n = n, media = mean(x), mediana = median(x),
      dp = s, ep = ep, minimo = min(x), q1 = unname(quantile(x, .25)),
      q3 = unname(quantile(x, .75)), maximo = max(x),
      ic_inf = mean(x) - qt(.975, n - 1) * ep,
      ic_sup = mean(x) + qt(.975, n - 1) * ep)
  })
  do.call(rbind, z)
}

# Diagnosticos graficos comuns a todos os modelos normais desta oficina.
# Linhas 4/n e 2p/n sao referencias de triagem, NUNCA regras de exclusao.
diagnosticar <- function(modelo, ids, nome) {
  n <- nobs(modelo); p <- modelo$rank
  z <- data.frame(id = ids, ajustado = fitted(modelo),
    residuo = residuals(modelo), padronizado = rstandard(modelo),
    alavancagem = hatvalues(modelo), cook = cooks.distance(modelo))
  z$rotulo <- ifelse(z$cook > 4/n | abs(z$padronizado) > 2, z$id, "")
  exportar(z, paste0(nome, "_diagnostico"))
  g1 <- ggplot(z, aes(ajustado, padronizado)) +
    geom_hline(yintercept = 0, linetype = 2, color = "grey50") +
    geom_point(size = 2, color = "#0072B2") +
    geom_text(aes(label = rotulo), vjust = -0.7, check_overlap = TRUE, size = 3) +
    labs(title = "A | Residuos versus ajuste", x = "Valor ajustado",
         y = "Residuo padronizado")
  g2 <- ggplot(z, aes(sample = padronizado)) + stat_qq(color = "#0072B2") +
    stat_qq_line(color = "#CC6677") +
    labs(title = "B | Q-Q dos residuos", x = "Quantil normal teorico",
         y = "Quantil residual observado")
  g3 <- ggplot(z, aes(ajustado, sqrt(abs(padronizado)))) +
    geom_point(size = 2, color = "#009E73") +
    labs(title = "C | Escala-localizacao", x = "Valor ajustado",
         y = "Raiz de |residuo padronizado|")
  g4 <- ggplot(z, aes(alavancagem, cook)) +
    geom_hline(yintercept = 4/n, linetype = 2, color = "#CC6677") +
    geom_vline(xintercept = 2*p/n, linetype = 3, color = "grey50") +
    geom_point(size = 2, color = "#0072B2") +
    geom_text(aes(label = rotulo), vjust = -0.7, check_overlap = TRUE, size = 3) +
    labs(title = "D | Influencia e alavancagem", x = "Alavancagem h",
         y = "Distancia de Cook")
  salvar(painel(list(g1, g2, g3, g4)), paste0(nome, "_painel"),
         paste("Diagnosticos:", nome), largura = 11, altura = 8)
  invisible(z)
}

# Matriz HC3: analise de sensibilidade a heterocedasticidade, nao a dependencia.
# V = (X'X)^-1 X' diag[e_i^2/(1-h_i)^2] X (X'X)^-1.
# Inferencia normal assintotica, explicita; nao e F classico exato.
# log_p preserva valores abaixo da resolucao numerica. p_limite_numerico=TRUE
# indica censura no menor double positivo normal, e nao uma probabilidade exata.
coeficientes_hc3 <- function(modelo) {
  X <- model.matrix(modelo)
  stopifnot(qr(X)$rank == ncol(X))
  pao <- solve(crossprod(X))
  u <- residuals(modelo) / (1 - hatvalues(modelo))
  V <- pao %*% crossprod(X * u) %*% pao
  ep <- sqrt(diag(V)); b <- coef(modelo)
  log_p <- log(2) + pnorm(-abs(b/ep), log.p = TRUE)
  data.frame(termo = names(b), estimativa = unname(b), ep_hc3 = ep,
    ic_inf = b - qnorm(.975) * ep, ic_sup = b + qnorm(.975) * ep,
    p_assintotico = exp(pmax(log_p, log(.Machine$double.xmin))),
    log_p = log_p, p_limite_numerico = log_p < log(.Machine$double.xmin),
    row.names = NULL)
}
coeficientes_classicos <- function(modelo) {
  b <- summary(modelo)$coefficients; ic <- confint(modelo)
  data.frame(termo = rownames(b), estimativa = b[, 1], ep = b[, 2],
    t = b[, 3], p = b[, 4], ic_inf = ic[, 1], ic_sup = ic[, 2], row.names = NULL)
}

# 1. AUDITORIA: PERGUNTA, DELINEAMENTO E UNIDADE -------------------------------
dic <- read.csv("dados/experimento_decomposicao.csv")
aves <- read.csv("dados/comunidades_amazonicas.csv")
dbc <- read.csv("dados/decomposicao_blocos.csv")
dic$tratamento <- factor(dic$tratamento, levels = c("Baixa", "Media", "Alta"))
aves$ambiente <- factor(aves$ambiente,
                       levels = c("Conservado", "Mosaico", "Restauracao"))
dbc$tratamento <- factor(dbc$tratamento, levels = levels(dic$tratamento))
dbc$bloco <- factor(dbc$bloco)
stopifnot(!anyNA(dic), !anyNA(aves), !anyNA(dbc),
  !anyDuplicated(dic$recipiente), !anyDuplicated(aves$local),
  nrow(dic) == 24, all(table(dic$tratamento) == 8),
  nrow(aves) == 36, all(table(aves$ambiente) == 12),
  all(aves$esforco_horas == 4),
  all(aves$diversidade_shannon <= log(aves$riqueza)),
  all(dic$perda_pct > 0 & dic$perda_pct < 100),
  all(table(dbc$bloco, dbc$tratamento) == 1))
comentar("1 | UNIDADE: 24 recipientes independentes no DIC; 36 localidades de aves; ",
  "18 unidades no DBC. Todos os dados sao simulados. Pontos de escuta e leituras ",
  "tecnicas nao representam replicas adicionais de ambiente ou tratamento.")
str(dic); str(aves)
exportar(resumir(dic, "perda_pct", "tratamento"), "01_descricao_dic")
exportar(resumir(aves, "diversidade_shannon", "ambiente"), "01_descricao_aves")

# 2. EXPLORACAO VISUAL: MOSTRAR A INFORMACAO ANTES DO VALOR-p ------------------
# Pausa em aula: pedir que a turma antecipe diferencas, dispersao e sobreposicao.
g <- ggplot(dic, aes(tratamento, perda_pct, color = tratamento)) +
  geom_boxplot(aes(fill = tratamento), alpha = .12, width = .45,
               outlier.shape = NA, color = "grey35") +
  geom_point(position = position_jitter(width = .10, seed = semente), size = 3) +
  scale_color_manual(values = cores) + scale_fill_manual(values = cores) +
  labs(title = "Primeiro os dados: decomposicao sob tres umidades",
    subtitle = "Cada ponto e um recipiente independente; oito por tratamento",
    x = "Umidade", y = "Perda de massa (%)",
    caption = "Dados simulados. Distribuicoes nao demonstram, sozinhas, causalidade.") +
  theme(legend.position = "none")
salvar(g, "01_dic_dados", "Decomposicao: dados individuais e boxplots")

g <- ggplot(dic, aes(perda_pct, fill = tratamento)) +
  geom_histogram(binwidth = 3, boundary = 0, color = "white", alpha = .8) +
  facet_wrap(~ tratamento, nrow = 1) + scale_fill_manual(values = cores) +
  labs(title = "Forma e posicao das distribuicoes",
    subtitle = "Mesma largura de classe e mesma escala entre grupos",
    x = "Perda de massa (%)", y = "Numero de recipientes",
    caption = "Com n=8 por grupo, histogramas tem baixa resolucao; examine os pontos.") +
  theme(legend.position = "none")
salvar(g, "02_dic_histogramas", "Histogramas com escala comum")

# 3. HIPOTESES, SOMAS DE QUADRADOS E TESTE F ----------------------------------
# H0: mu_Baixa = mu_Media = mu_Alta; H1: pelo menos uma media difere.
# Y_ij = mu + tau_i + erro_ij, com erros independentes, normais e variancia comum.
# A casualizacao individual sustenta a comparacao experimental; nao a estetica.
m_dic <- aov(perda_pct ~ tratamento, data = dic)
tab_dic <- as.data.frame(anova(m_dic))
tab_dic$fonte <- rownames(tab_dic)
exportar(tab_dic, "02_anova_dic")
N <- nrow(dic); a <- nlevels(dic$tratamento)
media_geral <- mean(dic$perda_pct)
sq_total <- sum((dic$perda_pct - media_geral)^2)
sq_erro <- sum(residuals(m_dic)^2)
sq_trat <- sq_total - sq_erro
qm_trat <- sq_trat / (a - 1)
qm_erro <- sq_erro / (N - a)
F_obs <- qm_trat / qm_erro
F_critico <- qf(1 - alpha, df1 = a - 1, df2 = N - a)
p_F <- pf(F_obs, a - 1, N - a, lower.tail = FALSE)
stopifnot(abs(F_obs - tab_dic$`F value`[1]) < 1e-9,
          abs(sq_total - (sq_trat + sq_erro)) < 1e-9)

# Efeito global: eta2 e omega2 (estimador com correcao de vies).
# Nao classificar por limiares universais; a escala da resposta e mais tangivel.
eta2 <- sq_trat / sq_total
omega2 <- (sq_trat - (a - 1) * qm_erro) / (sq_total + qm_erro)
exportar(data.frame(SQ_total = sq_total, SQ_tratamento = sq_trat,
  SQ_residuo = sq_erro, F_observado = F_obs, F_critico = F_critico,
  gl1 = a - 1, gl2 = N - a, p = p_F, eta2 = eta2, omega2 = omega2),
  "03_decomposicao_F_efeitos")
comentar("3 | F(", a - 1, ", ", N - a, ") = ", fmt(F_obs),
  "; F critico = ", fmt(F_critico), "; p = ", fp(p_F),
  ". A razao compara variacao entre medias com variacao residual. ",
  "Eta2 = ", fmt(eta2), " e omega2 = ", fmt(omega2),
  " descrevem magnitude global neste cenario; F nao identifica os pares.")

# Representacao de desvios: mesmo eixo vertical para as duas decomposicoes.
desvios <- rbind(
  data.frame(dic, painel = "A | Desvios em relacao a media geral",
             referencia = media_geral),
  data.frame(dic, painel = "B | Residuos em relacao a media do tratamento",
             referencia = fitted(m_dic)))
desvios$indice <- as.integer(sub("R", "", desvios$recipiente))
g <- ggplot(desvios, aes(indice, perda_pct, color = tratamento)) +
  geom_segment(aes(xend = indice, y = referencia, yend = perda_pct), linewidth = .6) +
  geom_point(size = 2.3) + geom_point(aes(y = referencia), shape = 4, size = 2) +
  facet_wrap(~ painel, ncol = 1) + scale_color_manual(values = cores) +
  labs(title = "A ANOVA como decomposicao de distancias",
    x = "Indice do recipiente (nao e ordem temporal)", y = "Perda de massa (%)",
    caption = "Segmentos mostram desvios; SQ soma seus quadrados, nao seus comprimentos.")
salvar(g, "03_geometria_anova", "Geometria das somas de quadrados", altura = 7)

curva <- data.frame(F = seq(0, max(F_obs * 1.12, F_critico * 2), length.out = 2500))
curva$densidade <- df(curva$F, a - 1, N - a)
g <- ggplot(curva, aes(F, densidade)) +
  geom_area(data = subset(curva, F >= F_critico), fill = "#CC6677", alpha = .4) +
  geom_line(color = "#002D5A", linewidth = .8) +
  geom_vline(xintercept = F_critico, linetype = 2, color = "#CC6677") +
  geom_vline(xintercept = F_obs, color = "#006633", linewidth = .9) +
  annotate("label", x = F_obs, y = max(curva$densidade) * .45,
    label = paste0("F observado = ", fmt(F_obs, 2), "\np = ", fp(p_F)),
    hjust = 1, size = 3.7) +
  labs(title = "O teste F: comparar o observado com uma distribuicao nula",
    subtitle = paste0("F teorica com ", a - 1, " e ", N - a,
                      " gl; regiao critica de 5% em rosa"),
    x = "Estatistica F", y = "Densidade sob H0",
    caption = "Valor-p: area a direita do F observado; nao e probabilidade de H0.")
salvar(g, "04_distribuicao_F", "Distribuicao nula, F critico e F observado")

# 4. PRESSUPOSTOS E SENSIBILIDADE: SEM TRIAGEM MECANICA ------------------------
diag_dic <- diagnosticar(m_dic, dic$recipiente, "05_dic")
shapiro_dic <- shapiro.test(residuals(m_dic))
fligner_dic <- fligner.test(perda_pct ~ tratamento, data = dic)
print(shapiro_dic)
print(fligner_dic)
welch <- oneway.test(perda_pct ~ tratamento, data = dic, var.equal = FALSE)
print(welch)
variancias <- tapply(dic$perda_pct, dic$tratamento, var)
comentar("4a | Diagnostico do DIC: Shapiro dos residuos p = ",
  fp(shapiro_dic$p.value), "; Fligner p = ", fp(fligner_dic$p.value),
  "; maior/menor variancia amostral = ", fmt(max(variancias)/min(variancias), 2),
  ". O Q-Q e a dispersao devem acompanhar esses numeros; nao rejeicao nao ",
  "demonstra normalidade ou homogeneidade. A alavancagem e igual entre ",
  "recipientes neste DIC balanceado, logo a diferenca de influencia vem dos residuos.")
exportar(data.frame(metodo = c("F classico", "Welch"),
  estatistica = c(F_obs, unname(welch$statistic)),
  p = c(p_F, welch$p.value)), "04_sensibilidade_welch")
comentar("4 | Welch: F aproximado = ", fmt(unname(welch$statistic)),
  ", p = ", fp(welch$p.value), ". E uma sensibilidade a variancias distintas, ",
  "nao uma escolha automatica apos Shapiro ou Fligner. Welch nao valida Tukey ",
  "classico sob heterocedasticidade e nenhum destes procedimentos corrige dependencia.")

# Posicao e identificador nao sao tempo; inspecao da alocacao espacial simulada.
g <- ggplot(data.frame(posicao = dic$posicao, residuo = residuals(m_dic),
                       tratamento = dic$tratamento), aes(posicao, residuo)) +
  geom_hline(yintercept = 0, linetype = 2) +
  geom_point(aes(color = tratamento), size = 3) + scale_color_manual(values = cores) +
  labs(title = "Residuos e posicao casualizada", x = "Posicao", y = "Residuo (p.p.)",
    caption = "Ausencia de padrao nao prova independencia; o protocolo e determinante.")
salvar(g, "06_posicao", "Residuos por posicao experimental")

# 5. EXTENSAO: RANDOMIZACAO, OUTRA ORIGEM PARA A DISTRIBUICAO NULA ------------
# Mantem respostas fixas, realoca rotulos preservando oito unidades por grupo.
# No experimento completamente casualizado, testa a nula AGUDA de nenhum
# efeito em nenhuma unidade. Nao e a mesma nula fraca de igualdade de medias.
# Em estudo observacional, permutar livremente rotulos pode ser injustificado.
set.seed(semente)
F_perm <- replicate(B, {
  rotulos <- sample(dic$tratamento, replace = FALSE)
  medias_perm <- ave(dic$perda_pct, rotulos, FUN = mean)
  sq_e <- sum((dic$perda_pct - medias_perm)^2)
  ((sq_total - sq_e) / (a - 1)) / (sq_e / (N - a))
})
excedencias <- sum(F_perm >= F_obs)
p_random <- (excedencias + 1) / (B + 1)
exportar(data.frame(B = B, excedencias = excedencias,
  p_monte_carlo = p_random, resolucao = 1 / (B + 1)), "05_randomizacao")
comentar("5 | Randomizacao: ", excedencias, " de ", B,
  " realocacoes atingiram F >= F observado; p Monte Carlo = ", fp(p_random),
  ". A correcao +1 impede p=0. Resolucao = ", fmt(1/(B+1), 4),
  "; nao espere reproduzir p parametrico de ordem 10^-7 com 4999 realocacoes. ",
  "A validade da randomizacao depende do mecanismo de alocacao e da nula aguda.")
g <- ggplot(data.frame(F = F_perm), aes(F)) +
  geom_histogram(bins = 45, fill = "#4477AA", color = "white") +
  geom_vline(xintercept = F_obs, color = "#006633", linewidth = 1) +
  labs(title = "O que a casualizacao produziria sob ausencia de efeitos?",
    subtitle = paste(B, "realocacoes; linha verde = F observado"),
    x = "F sob realocacao aleatoria", y = "Numero de realocacoes",
    caption = paste0("p Monte Carlo corrigido = ", fp(p_random),
                     ". Esta nao e uma simulacao de novos dados de campo."))
salvar(g, "07_randomizacao", "Teste de randomizacao do DIC")

# 6. TUKEY: ESTIMATIVAS, IC SIMULTANEOS E MAGNITUDE ----------------------------
tk <- as.data.frame(TukeyHSD(m_dic, "tratamento", conf.level = .95)$tratamento)
tk$comparacao <- rownames(tk)
names(tk)[1:4] <- c("diferenca", "ic_inf", "ic_sup", "p_ajustado")
exportar(tk, "06_tukey_dic")
# A ordem dos fatores fixa o sentido: Alta-Baixa = media Alta menos Baixa.
# Nao sao testes t sem ajuste; a familia e dos tres pares.
g <- ggplot(tk, aes(diferenca, reorder(comparacao, diferenca))) +
  geom_vline(xintercept = 0, linetype = 2, color = "grey45") +
  geom_segment(aes(x = ic_inf, xend = ic_sup,
                   yend = reorder(comparacao, diferenca)), linewidth = 1,
               color = "#0072B2") +
  geom_point(size = 3.5, color = "#006633") +
  labs(title = "Quais diferencas? Estimativas e intervalos simultaneos",
    subtitle = "Tukey: familia dos tres pares; cobertura simultanea de 95%",
    x = "Diferenca na perda de massa (pontos percentuais)", y = NULL,
    caption = "Cruzar zero significa evidencia insuficiente de diferenca; nao equivalencia.")
salvar(g, "08_tukey", "Tukey: intervalos das diferencas")

medias_dic <- resumir(dic, "perda_pct", "tratamento")
medias_dic$grupo <- factor(medias_dic$grupo, levels = levels(dic$tratamento))
# Aqui IC de medias usam QM residual comum, em coerencia com o modelo ANOVA.
medias_dic$ep_modelo <- sqrt(qm_erro / medias_dic$n)
medias_dic$ic_inf_modelo <- medias_dic$media - qt(.975, N-a)*medias_dic$ep_modelo
medias_dic$ic_sup_modelo <- medias_dic$media + qt(.975, N-a)*medias_dic$ep_modelo
exportar(medias_dic, "07_medias_dic_IC_individuais")
g <- ggplot(dic, aes(tratamento, perda_pct)) +
  geom_point(aes(color = tratamento),
    position = position_jitter(width = .10, seed = semente), alpha = .55, size = 2.5) +
  geom_errorbar(data = medias_dic,
    aes(x = grupo, y = media, ymin = ic_inf_modelo, ymax = ic_sup_modelo),
    inherit.aes = FALSE, width = .10, linewidth = .8) +
  geom_point(data = medias_dic, aes(grupo, media), inherit.aes = FALSE,
             shape = 23, fill = "white", size = 4) +
  scale_color_manual(values = cores) + theme(legend.position = "none") +
  labs(title = "Medias e incerteza sem esconder as observacoes",
    x = "Umidade", y = "Perda de massa (%)",
    caption = "Losangos e barras: medias e IC95% individuais. Nao sao os IC de Tukey.")
salvar(g, "09_medias_observacoes", "Medias e IC individuais com dados brutos")
linha_ab <- tk[tk$comparacao == "Alta-Baixa", ]
comentar("6 | Alta menos Baixa = ", fmt(linha_ab$diferenca),
  " p.p.; IC95% simultaneo [", fmt(linha_ab$ic_inf), "; ",
  fmt(linha_ab$ic_sup), "]; p ajustado = ", fp(linha_ab$p_ajustado),
  ". Diferenca entre porcentagens e expressa em pontos percentuais. ",
  "A perda de massa nao mede diretamente toda a ciclagem de nutrientes. ",
  "Relevancia exige um criterio ecologico externo, nao apenas p<0.05.")

# 7. AVES: EXPLORAR AS ESCALAS E OS GRUPOS ANTES DA RETA -----------------------
# Topografia = DP da elevacao em janela espacial comum, em metros.
# H = Shannon, log natural. Esforco padronizado nao garante deteccao constante.
longa <- do.call(rbind, lapply(c("diversidade_shannon", "topografia_m",
                               "precipitacao_mm", "riqueza"), function(v) {
  data.frame(variavel = v, valor = aves[[v]], ambiente = aves$ambiente)
}))
g <- ggplot(longa, aes(valor)) + geom_histogram(bins = 10, color = "white",
  fill = "#006633") + facet_wrap(~ variavel, scales = "free", ncol = 2) +
  labs(title = "Escalas diferentes pedem leituras diferentes",
    subtitle = "Shannon e continuo; riqueza e contagem; topografia e chuva tem unidades proprias",
    x = "Valor na unidade da variavel", y = "Numero de localidades",
    caption = "Riqueza da base foi ajustada na simulacao para H <= log(S); nao ajustar Poisson mecanicamente.")
salvar(g, "10_aves_distribuicoes", "Distribuicoes da base de aves", altura = 7)

g <- ggplot(aves, aes(topografia_m, diversidade_shannon, color = ambiente)) +
  geom_point(size = 3) + geom_rug(alpha = .5) + scale_color_manual(values = cores) +
  labs(title = "Uma associacao pode combinar gradientes e diferencas entre ambientes",
    x = "Heterogeneidade topografica (DP da elevacao, m)",
    y = "Shannon (log natural)",
    caption = "Dados observacionais simulados; a cor identifica ambientes, nao tratamentos casualizados.")
salvar(g, "11_aves_dispersao", "Topografia, Shannon e ambientes")

# 8. REGRESSAO SIMPLES: A INCLINACAO, O F E A PREDICAO -------------------------
# H0: beta_topografia = 0. Em uma regressao simples com intercepto, F=t^2.
m_simples <- lm(diversidade_shannon ~ topografia_m, data = aves)
print(summary(m_simples))
exportar(coeficientes_classicos(m_simples), "08_coef_simples")
anova_simples <- anova(m_simples)
exportar(data.frame(fonte = rownames(anova_simples), anova_simples,
                    row.names = NULL), "09_anova_regressao_simples")
F_reg <- unname(summary(m_simples)$fstatistic[1])
t_reg <- summary(m_simples)$coefficients["topografia_m", "t value"]
stopifnot(abs(F_reg - t_reg^2) < 1e-8)
comentar("8 | Regressao simples: H = ", fmt(coef(m_simples)[1], 5),
  " + ", fmt(coef(m_simples)[2], 5), " * topografia_m. F = ", fmt(F_reg),
  " = t^2 = ", fmt(t_reg^2), ". R2 = ", fmt(summary(m_simples)$r.squared),
  ". O intercepto em 0 m esta fora do dominio observado, de ",
  fmt(min(aves$topografia_m), 1), " a ", fmt(max(aves$topografia_m), 1),
  " m. A reta simples nao isola a associacao dos demais fatores.")

grade <- data.frame(topografia_m = seq(min(aves$topografia_m),
                                      max(aves$topografia_m), length.out = 160))
ic_media <- predict(m_simples, grade, interval = "confidence", level = .95)
ip_local <- predict(m_simples, grade, interval = "prediction", level = .95)
grade$ajustado <- ic_media[, "fit"]
grade$ic_inf <- ic_media[, "lwr"]; grade$ic_sup <- ic_media[, "upr"]
grade$ip_inf <- ip_local[, "lwr"]; grade$ip_sup <- ip_local[, "upr"]
exportar(grade, "10_grade_predicao_simples")
g <- ggplot(grade, aes(topografia_m, ajustado)) +
  geom_ribbon(aes(ymin = ip_inf, ymax = ip_sup), fill = "grey80", alpha = .55) +
  geom_ribbon(aes(ymin = ic_inf, ymax = ic_sup), fill = "#56B4E9", alpha = .5) +
  geom_line(color = "#0072B2", linewidth = 1) +
  geom_point(data = aves, aes(topografia_m, diversidade_shannon, color = ambiente),
             inherit.aes = FALSE, size = 2.5) + scale_color_manual(values = cores) +
  labs(title = "Confianca na media nao e predicao de um novo local",
    subtitle = "Azul: IC95% pontual da media | Cinza: IP95% de uma nova observacao",
    x = "Heterogeneidade topografica (m)", y = "Shannon",
    caption = "Intervalos condicionados ao modelo simples; nao cobrem automaticamente confundimento.")
salvar(g, "12_regressao_intervalos", "Regressao: IC da media versus predicao")
diag_simples <- diagnosticar(m_simples, aves$local, "13_regressao_simples")
imax <- which.max(diag_simples$cook)
comentar("8a | Regressao simples: maior Cook no local ", aves$local[imax],
  " (D = ", fmt(diag_simples$cook[imax]),
  "). Inspecione no grafico a sua posicao relativa aos demais ambientes; ",
  "a discrepancia pode refletir estrutura omitida. O local permanece na analise.")

# 9. REGRESSAO MULTIPLA: ESCALAS INTERPRETAVEIS E TESTES F PARCIAIS -------------
# Centrar topografia em 15 m e expressar a variacao em passos de 10 m.
# Chuva centrada em 2400 mm e expressa por 100 mm. Nao muda ajuste ou F.
aves$topo_10m <- (aves$topografia_m - 15) / 10
aves$chuva_100mm <- (aves$precipitacao_mm - 2400) / 100
m_completo <- lm(diversidade_shannon ~ topo_10m + chuva_100mm + ambiente,
                 data = aves)
m_sem_topo <- update(m_completo, . ~ . - topo_10m)
m_sem_ambiente <- update(m_completo, . ~ . - ambiente)
stopifnot(identical(rownames(model.frame(m_completo)),
                   rownames(model.frame(m_sem_topo))),
          identical(rownames(model.frame(m_completo)),
                    rownames(model.frame(m_sem_ambiente))))
F_topo <- anova(m_sem_topo, m_completo)
F_ambiente <- anova(m_sem_ambiente, m_completo)
print(summary(m_completo)); print(F_topo); print(F_ambiente)
exportar(data.frame(modelo = rownames(F_topo), F_topo, row.names = NULL),
         "11_F_parcial_topografia")
exportar(data.frame(modelo = rownames(F_ambiente), F_ambiente, row.names = NULL),
         "12_F_parcial_ambiente")
exportar(coeficientes_classicos(m_completo), "13_coef_multiplo")
exportar(coeficientes_hc3(m_completo), "14_coef_HC3")
print(drop1(m_completo, test = "F"))
# anova(um_modelo) produz SQ SEQUENCIAIS: a ordem pode importar.
# anova(reduzido, completo) explicita a contribuicao parcial do termo removido.
# Comparacao so e valida para modelos aninhados sobre as MESMAS observacoes.
comentar("9 | F parcial de topografia, controlando chuva e ambiente: F = ",
  fmt(F_topo$F[2]), ", p = ", fp(F_topo$`Pr(>F)`[2]),
  ". Ambiente e testado como termo de dois gl, nao por um unico coeficiente. ",
  "Ajustar preditores observados nao elimina confundimento nao medido.")

# Verificacao numerica do F parcial: reducao da SQ residual por gl adicionados.
q <- df.residual(m_sem_topo) - df.residual(m_completo)
F_parcial_manual <- ((deviance(m_sem_topo)-deviance(m_completo))/q) /
  (deviance(m_completo)/df.residual(m_completo))
stopifnot(abs(F_parcial_manual - F_topo$F[2]) < 1e-8)
diag_multiplo <- diagnosticar(m_completo, aves$local, "14_regressao_multipla")
imax_m <- which.max(diag_multiplo$cook)
comentar("9a | Modelo multiplo: maior Cook no local ", aves$local[imax_m],
  " (D = ", fmt(diag_multiplo$cook[imax_m]),
  "). Compare os paineis simples e multiplo e as tabelas de influencia. ",
  "Linhas de referencia sao alertas de investigacao, nao limites para eliminar locais.")

# Colinearidade dos preditores numericos condicionada ao restante do modelo.
vif_topo <- 1/(1-summary(lm(topo_10m ~ chuva_100mm + ambiente, aves))$r.squared)
vif_chuva <- 1/(1-summary(lm(chuva_100mm ~ topo_10m + ambiente, aves))$r.squared)
exportar(data.frame(termo = c("topo_10m", "chuva_100mm"),
                    VIF = c(vif_topo, vif_chuva)), "15_VIF_numericos")
# Nao aplicamos limiar universal de VIF, nem calculamos VIF unico para o fator.

# 10. VISUALIZAR ASSOCIACOES CONDICIONAIS E ROBUSTEZ ---------------------------
# Grade restrita ao intervalo de topografia observado DENTRO de cada ambiente.
# Chuva fixada em 2400 mm; conferir suporte deste valor em cada ambiente.
print(aggregate(precipitacao_mm ~ ambiente, aves, range))
condicional <- do.call(rbind, lapply(levels(aves$ambiente), function(grupo) {
  x <- aves$topografia_m[aves$ambiente == grupo]
  data.frame(ambiente = factor(grupo, levels = levels(aves$ambiente)),
             topografia_m = seq(min(x), max(x), length.out = 80))
}))
condicional$topo_10m <- (condicional$topografia_m - 15)/10
condicional$chuva_100mm <- 0
prev <- predict(m_completo, condicional, interval = "confidence")
condicional$media <- prev[, 1]; condicional$ic_inf <- prev[, 2]
condicional$ic_sup <- prev[, 3]
# Pontos ajustados apenas para chuva: mantem ambiente, topografia e residuos.
aves$H_corrigido_chuva <- aves$diversidade_shannon -
  coef(m_completo)["chuva_100mm"] * aves$chuva_100mm
g <- ggplot(condicional, aes(topografia_m, media, color = ambiente, fill = ambiente)) +
  geom_ribbon(aes(ymin = ic_inf, ymax = ic_sup), alpha = .18, color = NA) +
  geom_line(linewidth = 1) +
  geom_point(data = aves, aes(topografia_m, H_corrigido_chuva), size = 2,
             alpha = .75) + facet_wrap(~ ambiente, nrow = 1) +
  scale_color_manual(values = cores) + scale_fill_manual(values = cores) +
  theme(legend.position = "none") +
  labs(title = "Topografia apos ajuste por chuva e ambiente",
    subtitle = "Linhas e IC: media a 2400 mm de chuva; pontos corrigidos pelo termo de chuva",
    x = "Heterogeneidade topografica (m)", y = "Shannon ajustado para chuva",
    caption = "Modelo aditivo: mesma inclinacao entre ambientes. Faixas sao pontuais e condicionais.")
salvar(g, "15_efeitos_condicionais", "Efeitos condicionais por ambiente", largura = 11)

classico <- coeficientes_classicos(m_completo)
hc3 <- coeficientes_hc3(m_completo)
nomes_efeitos <- c(topo_10m = "Topografia: por 10 m",
  chuva_100mm = "Chuva: por 100 mm", ambienteMosaico = "Mosaico - Conservado",
  ambienteRestauracao = "Restauracao - Conservado")
fl <- rbind(
  data.frame(termo = classico$termo, estimativa = classico$estimativa,
    ic_inf = classico$ic_inf, ic_sup = classico$ic_sup, metodo = "Classico: t"),
  data.frame(termo = hc3$termo, estimativa = hc3$estimativa,
    ic_inf = hc3$ic_inf, ic_sup = hc3$ic_sup, metodo = "HC3: normal assintotica"))
fl <- subset(fl, termo != "(Intercept)")
fl$efeito <- unname(nomes_efeitos[fl$termo])
g <- ggplot(fl, aes(estimativa, metodo, color = metodo)) +
  geom_vline(xintercept = 0, linetype = 2, color = "grey60") +
  geom_segment(aes(x = ic_inf, xend = ic_sup, yend = metodo), linewidth = .8) +
  geom_point(size = 2.5) + facet_wrap(~ efeito, scales = "free_x", ncol = 2) +
  scale_color_manual(values = c("#0072B2", "#CC6677")) +
  labs(title = "Estimativas iguais, hipoteses de variancia diferentes",
    x = "Associacao estimada em Shannon por incremento indicado", y = NULL,
    caption = "HC3 e sensibilidade a heterocedasticidade; nao corrige dependencia ou confundimento.") +
  theme(legend.position = "none")
salvar(g, "16_coeficientes_robustez", "Intervalos classicos e HC3", largura = 11, altura = 7)

# Interacao e uma HIPOTESE adicional, demonstrada como extensao previamente
# identificada. Nao escolher a historia ecologica apenas pelo menor p.
m_interacao <- update(m_completo, . ~ . + topo_10m:ambiente)
tab_interacao <- anova(m_completo, m_interacao)
exportar(data.frame(modelo = rownames(tab_interacao), tab_interacao,
                    row.names = NULL), "16_interacao_exploratoria")
comentar("10 | Extensao identificada como exploratoria: adicionar interacao ",
  "topografia:ambiente produz F = ", fmt(tab_interacao$F[2]),
  ", p = ", fp(tab_interacao$`Pr(>F)`[2]),
  ". Nao rejeitar a interacao nao prova igualdade das inclinacoes; ",
  "com 12 locais por grupo, a precisao e limitada. O modelo principal permanece ",
  "o aditivo definido pela pergunta, nao por uma busca automatica de significancia.")

# 11. INFLUENCIA E PREVISAO: AJUSTE NAO E VALIDACAO EXTERNA ---------------------
# Reajustes leave-one-out quantificam sensibilidade; nao removemos locais.
loo <- do.call(rbind, lapply(seq_len(nrow(aves)), function(i) {
  mi <- lm(diversidade_shannon ~ topo_10m + chuva_100mm + ambiente,
           data = aves[-i, ])
  data.frame(local_omitido = aves$local[i],
             beta_topo_10m = unname(coef(mi)["topo_10m"]))
}))
exportar(loo, "17_sensibilidade_omissao")
g <- ggplot(loo, aes(beta_topo_10m, reorder(local_omitido, beta_topo_10m))) +
  geom_vline(xintercept = coef(m_completo)["topo_10m"],
              color = "#CC6677", linetype = 2) +
  geom_point(color = "#0072B2", size = 2) +
  labs(title = "Quanto a inclinacao depende de uma localidade?",
    subtitle = "Um reajuste por local omitido; linha = estimativa com todos os locais",
    x = "Coeficiente de topografia (Shannon por 10 m)", y = "Local omitido",
    caption = "Analise de sensibilidade, nao procedimento de selecao/exclusao de observacoes.")
salvar(g, "17_sensibilidade_locais", "Sensibilidade leave-one-out da inclinacao", altura = 9)

# PRESS/n: validacao cruzada leave-one-out analitica para regressao OLS.
# Independencia por local e essencial; para campo agrupado, CV aleatoria pode
# ser otimista. CV espacial/temporal requer blocos e novos criterios de desenho.
metricas <- do.call(rbind, lapply(c("Simples", "Multiplo"), function(nome) {
  m <- if (nome == "Simples") m_simples else m_completo
  data.frame(modelo = nome, n = nobs(m), parametros = m$rank,
    R2 = summary(m)$r.squared, R2_ajustado = summary(m)$adj.r.squared,
    RMSE_ajuste = sqrt(mean(residuals(m)^2)),
    RMSE_LOO = sqrt(mean((residuals(m)/(1-hatvalues(m)))^2)))
}))
exportar(metricas, "18_metricas_ajuste_LOO")
comentar("11 | Modelo multiplo: R2 ajustado = ", fmt(metricas$R2_ajustado[2]),
  "; RMSE ajuste = ", fmt(metricas$RMSE_ajuste[2]),
  "; RMSE LOO = ", fmt(metricas$RMSE_LOO[2]),
  ". O LOO e interno ao conjunto simulado, nao validacao regional externa. ",
  "A inclinacao ao omitir um local varia de ", fmt(min(loo$beta_topo_10m)),
  " a ", fmt(max(loo$beta_topo_10m)), " Shannon/10 m.")

# 12. EXTENSAO DBC: O MESMO TEMA, OUTRA ESTRUTURA EXPERIMENTAL ----------------
# Seis blocos completos; uma unidade por tratamento em cada bloco.
# Modelo aditivo: nao se estima separadamente interacao bloco:tratamento.
m_blocos <- aov(perda_pct ~ bloco + tratamento, data = dbc)
m_blocos_sem_trat <- lm(perda_pct ~ bloco, data = dbc)
F_dbc <- anova(m_blocos_sem_trat, m_blocos)
print(summary(m_blocos)); print(F_dbc)
tk_dbc <- as.data.frame(TukeyHSD(m_blocos, "tratamento")$tratamento)
tk_dbc$comparacao <- rownames(tk_dbc)
exportar(tk_dbc, "19_tukey_DBC")
exportar(data.frame(modelo = rownames(F_dbc), F_dbc, row.names = NULL),
         "20_F_parcial_DBC")
g <- ggplot(dbc, aes(tratamento, perda_pct, group = bloco, color = bloco)) +
  geom_line(alpha = .65) + geom_point(size = 2.5) +
  labs(title = "Blocos tornam visivel uma fonte de heterogeneidade",
    subtitle = "Cada linha conecta unidades diferentes pertencentes ao mesmo bloco",
    x = "Umidade", y = "Perda de massa (%)",
    caption = "Os niveis de umidade sao categoricos; as linhas nao representam uma serie temporal.")
salvar(g, "18_blocos", "Perfis por bloco no DBC")
diagnosticar(m_blocos, paste(dbc$bloco, dbc$tratamento, sep = ":"), "19_dbc")
comentar("12 | DBC: F de tratamento ajustado para bloco = ", fmt(F_dbc$F[2]),
  ", com 2 e ", df.residual(m_blocos), " gl; p = ", fp(F_dbc$`Pr(>F)`[2]),
  ". Os dados do DBC pertencem a outro experimento: nao comparar seus QM com ",
  "os do DIC como se fosse uma avaliacao controlada do ganho de precisao.")

# 13. SINTESE CIENTIFICA E MATERIAL PARA PROJECAO ------------------------------
b <- coef(m_completo)["topo_10m"]
ic <- confint(m_completo)["topo_10m", ]
comentar("SINTESE PARA REDACAO | No experimento simulado, a perda de massa diferiu ",
  "entre umidades (F2,21 = ", fmt(F_obs, 2), "; p = ", fp(p_F),
  "). A diferenca Alta-Baixa foi ", fmt(linha_ab$diferenca, 2),
  " p.p. (IC simultaneo 95% ", fmt(linha_ab$ic_inf, 2), " a ",
  fmt(linha_ab$ic_sup, 2), "). Em 36 localidades de aves simuladas, ",
  "a associacao parcial entre Shannon e topografia foi ", fmt(b),
  " por 10 m (IC95% ", fmt(ic[1]), " a ", fmt(ic[2]),
  "), ajustada por chuva e ambiente. A associacao observacional nao ",
  "estabelece causalidade. Nenhum resultado descreve a Amazonia real.")
writeLines(comentarios, "saidas/comentarios_resultados.txt", useBytes = TRUE)
capture.output(sessionInfo(), file = "saidas/sessionInfo.txt")
saveRDS(list(dic = m_dic, simples = m_simples, multiplo = m_completo,
  interacao_exploratoria = m_interacao, dbc = m_blocos,
  tukey_dic = tk, metricas = metricas, semente = semente, B = B),
  "saidas/modelos_e_resultados.rds")

# HTML local: usa as figuras ja salvas, nao exige internet, servidor ou Quarto.
escapar <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  gsub(">", "&gt;", x, fixed = TRUE)
}
tabela_html <- function(dados) {
  d <- lapply(dados, function(x) {
    if (is.numeric(x)) ifelse(is.na(x), "--", formatC(x, format = "g", digits = 4))
    else as.character(x)
  })
  d <- as.data.frame(d, check.names = FALSE)
  linhas <- apply(d, 1, function(x) paste0("<tr><td>",
    paste(escapar(x), collapse = "</td><td>"), "</td></tr>"))
  paste0('<div class="tabela"><table><thead><tr><th>',
    paste(escapar(names(d)), collapse = '</th><th>'),
    '</th></tr></thead><tbody>', paste(linhas, collapse = ''),
    '</tbody></table></div>')
}
indice <- paste0('<li><a href="#', names(galeria), '">',
  vapply(galeria, function(x) escapar(x$titulo), character(1)), '</a></li>',
  collapse = '')
secoes <- vapply(names(galeria), function(nome) {
  paste0('<section id="', nome, '"><h2>', escapar(galeria[[nome]]$titulo),
    '</h2><img loading="lazy" src="figuras/', nome,
    '.png" alt="', escapar(galeria[[nome]]$titulo),
    '"><p><a href="figuras/', nome, '.pdf">Abrir figura vetorial em PDF</a></p></section>')
}, character(1))
html <- paste0('<!doctype html><html lang="pt-BR"><meta charset="utf-8">',
  '<meta name="viewport" content="width=device-width, initial-scale=1">',
  '<title>Oficina docente | ANOVA e regressao</title><style>',
  'body{font:18px/1.6 system-ui,sans-serif;max-width:1150px;margin:40px auto;',
  'padding:0 24px;color:#17332d;background:#f7faf8}h1,h2{color:#002d5a}',
  'section{background:white;padding:24px;margin:24px 0;border-left:4px solid #006633}',
  'img{max-width:100%;height:auto}a{color:#006633}li{margin:10px 0}',
  '.aviso{border:1px solid #cc6677;padding:16px}.tabela{overflow-x:auto}',
  'table{border-collapse:collapse;width:100%;font-size:15px;background:white}',
  'td,th{padding:9px;text-align:left;border-bottom:1px solid #ddd}',
  '@media print{section{break-inside:avoid}}</style>',
  '<h1>ANOVA, teste F, Tukey e regressao</h1>',
  '<p>Oficina docente | RENAmazon / UEAP | 27 de outubro de 2026</p>',
  '<p class="aviso">Todos os dados sao simulados. O material demonstra metodos, ',
  'nao fornece estimativas regionais de campo.</p>',
  '<p>Sequencia: desenho → exploracao → estimacao → diagnostico → inferencia → interpretacao.</p>',
  '<h2>Comentarios calculados a partir desta execucao</h2><ol>',
  paste0('<li>', escapar(comentarios), '</li>', collapse = ''), '</ol>',
  '<h2>Resultados para leitura em aula</h2><h3>ANOVA do DIC</h3>', tabela_html(tab_dic),
  '<h3>Tukey: diferencas em pontos percentuais</h3>', tabela_html(tk),
  '<h3>Regressao: coeficientes classicos</h3>', tabela_html(classico),
  '<h3>Ajuste e avaliacao interna LOO</h3>', tabela_html(metricas),
  '<h2>Galeria para discussao em aula</h2><ol>', indice, '</ol>',
  paste(secoes, collapse = '\n'),
  '<h2>Fontes metodologicas</h2><p>Quinn &amp; Keough (2002); Zuur, Ieno &amp; Elphick (2010); ',
  'Wasserstein &amp; Lazar (2016); documentacao oficial do R: ',
  '<a href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/anova.lm.html">anova.lm</a>, ',
  '<a href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/TukeyHSD.html">TukeyHSD</a>, ',
  '<a href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/predict.lm.html">predict.lm</a>, ',
  '<a href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/influence.measures.html">influence.measures</a>.</p></html>')
writeLines(enc2utf8(html), "saidas/relatorio_aula.html", useBytes = TRUE)
cat("\nConcluido. Abra saidas/relatorio_aula.html para projetar a galeria.\n")
