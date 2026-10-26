# Validacao numerica independente dos objetos do script principal.
# Execute apos atividade_docente.R; nao e necessario para acompanhar a aula.
dic <- read.csv("dados/experimento_decomposicao.csv")
aves <- read.csv("dados/comunidades_amazonicas.csv")
dic$tratamento <- factor(dic$tratamento, levels = c("Baixa", "Media", "Alta"))
aves$ambiente <- factor(aves$ambiente,
                       levels = c("Conservado", "Mosaico", "Restauracao"))
aves$topo_10m <- (aves$topografia_m-15)/10
aves$chuva_100mm <- (aves$precipitacao_mm-2400)/100
m <- lm(perda_pct ~ tratamento, dic)
r <- lm(diversidade_shannon ~ topo_10m + chuva_100mm + ambiente, aves)
stopifnot(abs(anova(m)$`F value`[1] - 34.180876) < .001)
tukey <- read.csv("saidas/tabelas/06_tukey_dic.csv")
stopifnot(abs(tukey$diferenca[tukey$comparacao == "Alta-Baixa"]-17.62375)<1e-8)
stopifnot(abs(coef(r)["topo_10m"]-.268669903269074)<1e-12)

# HC3 conferido por outra construcao da matriz: soma de produtos externos.
X <- model.matrix(r); inv <- solve(crossprod(X)); V <- matrix(0,ncol(X),ncol(X))
for (i in seq_len(nrow(X))) {
  v <- X[i, ] * residuals(r)[i] / (1-hatvalues(r)[i])
  V <- V + tcrossprod(v)
}
V <- inv %*% V %*% inv
hc3 <- read.csv("saidas/tabelas/14_coef_HC3.csv")
stopifnot(max(abs(hc3$ep_hc3-sqrt(diag(V))))<1e-12,
          all(hc3$p_assintotico>0), all(is.finite(hc3$log_p)))

# LOO analitico conferido contra reajustes independentes de cada modelo.
pred_loo <- vapply(seq_len(nrow(aves)), function(i) {
  mi <- lm(diversidade_shannon ~ topo_10m + chuva_100mm + ambiente, aves[-i,])
  as.numeric(predict(mi, newdata = aves[i,,drop=FALSE]))
}, numeric(1))
rmse <- sqrt(mean((aves$diversidade_shannon-pred_loo)^2))
metricas <- read.csv("saidas/tabelas/18_metricas_ajuste_LOO.csv")
stopifnot(abs(rmse-metricas$RMSE_LOO[metricas$modelo=="Multiplo"])<1e-12)

# Desenho, predicoes e arquivos.
stopifnot(all(table(dic$tratamento)==8), !anyDuplicated(aves$local),
          all(aves$diversidade_shannon<=log(aves$riqueza)))
grade <- read.csv("saidas/tabelas/10_grade_predicao_simples.csv")
stopifnot(all(grade$ip_inf <= grade$ic_inf), all(grade$ip_sup >= grade$ic_sup))
stopifnot(length(list.files("saidas/figuras",pattern="\\.png$"))==19,
          length(list.files("saidas/figuras",pattern="\\.pdf$"))==19)
cat("VALIDADO: F, Tukey, coeficientes, HC3, LOO, limites e 19 pares de figuras.\n")
