# UNIDADE 1 | Da pergunta ecologica a uma tabela organizada.
# Abra o arquivo .Rproj antes de executar. Use Ctrl+Enter por bloco.

# 1. Ler dados: cada linha e uma localidade, nao uma ave.
dados <- read.csv("dados/comunidades_amazonicas.csv")
head(dados)
str(dados)
summary(dados)

# 2. Exercicio 1: identificar tipos de variaveis.
# ambiente: qualitativa nominal; riqueza: contagem discreta;
# precipitacao_mm: quantitativa continua; local: identificador.
dados$ambiente <- factor(dados$ambiente)
print(levels(dados$ambiente))

# 3. Exercicio 2: conferir tamanho e unidade de analise.
nrow(dados)
length(unique(dados$local))
table(dados$ambiente)
table(dados$esforco_horas)
# 36 localidades, 12 por ambiente e quatro horas em cada local.
# Os quatro pontos de cada local ja foram agregados.

# 4. Exercicio 3: procurar ausencias e valores impossiveis.
colSums(is.na(dados))
anyDuplicated(dados$local)
range(dados$riqueza)
range(dados$diversidade_shannon)
all(dados$diversidade_shannon <= log(dados$riqueza))
# NA significa ausencia de informacao; nao substitua por zero.
# H <= log(S) e uma checagem de coerencia, nao valida o estudo.

# 5. Exercicio 4: selecionar e exportar uma tabela simples.
consulta <- dados[, c("local", "ambiente", "riqueza")]
dir.create("resultados", showWarnings = FALSE)
write.csv(consulta, "resultados/u1_consulta.csv", row.names = FALSE)
# Uma tabela correta nao garante amostragem representativa.
# Para uma dissertacao, documente selecao dos locais e detectabilidade.
