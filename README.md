# disciplina-estatistica-aplicada-renamazon-ueap
Materiais da disciplina Estatística Aplicada no RENAMAZON/UEAP: aulas, apostilas, scripts em R e dados ecológicos.

## Apostila de Estatística Aplicada

**Estatística Aplicada à Ecologia, Biodiversidade e Recursos Naturais Amazônicos**  
Prof. Dr. Robson Borges de Lima · UEAP · edição 2026

Material no template institucional, com 42 páginas, sete unidades, 31 exercícios, gabarito e scripts completos em R ao final de cada unidade. Os exemplos abrangem diversidade de aves, clima e topografia, qualidade da água e decomposição de serapilheira.

- [Ler a apostila em PDF](estatistica-aplicada-ecologia/apostila_estatistica_aplicada.pdf)
- [Baixar o projeto completo em ZIP](apostila_estatistica_recursos_naturais_amazonicos.zip)
- [Acessar os scripts em R](estatistica-aplicada-ecologia/scripts_r)
- [Acessar os dados CSV](estatistica-aplicada-ecologia/dados)
- [Consultar o dicionário dos dados](estatistica-aplicada-ecologia/dados/DICIONARIO.md)
- [Consultar fontes LaTeX e instruções de reprodução](estatistica-aplicada-ecologia/README.md)
- [Consultar o registro de validação](estatistica-aplicada-ecologia/VALIDACAO.md)

**Todos os dados são simulados para ensino**, com semente fixa. Não representam observações de campo ou estimativas reais sobre a Amazônia.

### Reproduzir as análises

1. Baixe e extraia o ZIP ou clone o repositório.
2. Abra `estatistica-aplicada-ecologia/estatistica-aplicada-ecologia.Rproj` no RStudio.
3. Instale a dependência: `install.packages("ggplot2")`.
4. Execute os scripts por unidade ou, na pasta do projeto, `source("executar_tudo.R", encoding = "UTF-8")`.

Os arquivos CSV já estão incluídos. Os scripts utilizam principalmente R básico, com comentários em português e orientações de interpretação. O projeto também contém gráficos vetoriais, referências bibliográficas e instruções para compilar a apostila em LaTeX.
