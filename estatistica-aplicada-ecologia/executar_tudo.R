# Execute a partir da pasta principal (abra o .Rproj).
options(OutDec = ".")
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop("Instale ggplot2: install.packages('ggplot2')")
}
dir.create("resultados", showWarnings = FALSE)
dir.create("logs", showWarnings = FALSE)
arquivos <- list.files("scripts_r", pattern = "^[0-7].*\\.R$",
                        full.names = TRUE)
for (arquivo in arquivos) {
  message("Executando: ", arquivo)
  saida <- capture.output(source(arquivo, echo = TRUE,
                      max.deparse.length = 10000, encoding = "UTF-8"))
  writeLines(saida, file.path("logs", paste0(basename(arquivo), ".txt")))
}
capture.output(sessionInfo(), file = "logs/sessionInfo.txt")
graphics.off()
message("Concluido: consulte figuras/, resultados/ e logs/.")
