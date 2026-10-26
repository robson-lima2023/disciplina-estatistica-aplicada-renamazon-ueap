# Diagnóstico e decisões editoriais

Consulta em 26/10/2026. Escopo: aproximadamente 35 a 55 páginas, sete unidades e roteiros acessíveis a estudantes que não são programadores.

## Referências editoriais examinadas

- Cópia local `ordenacao-multivariada-ecologia-r/apostila/apostila_ordenacao_multivariada_novo.tex`, classe `ueap-apostila.cls`, bibliografia, diretórios e PDF de 238 páginas. Examinados preâmbulo, metadados, ambientes e estrutura dos primeiros capítulos; não se fez revisão integral das 238 páginas.
- A classe carrega `book` em A4 e 11 pt, Latin Modern, entrelinha de 1,5, margens de 2 a 2,2 cm, paleta verde/azul/dourado, sumário tocloft, títulos titlesec, cabeçalhos fancyhdr, tabelas booktabs, matemática amsmath, caixas tcolorbox e código listings. Há comandos de autoria, instituição, capa e ambientes conceito, atenção, exemplo, dica, objetivos e exercícios.
- O repositório remoto `disciplina-estatistica-aplicada-renamazon-ueap` foi consultado pelo conector GitHub. Sua raiz contém apenas README.md na referência main consultada; não forneceu outro template ou base.
- Acesso web direto aos repositórios retornou falha de cache. A análise do template utilizou a cópia local disponível, sem presumir características de arquivos inacessíveis.

## Materiais de apoio

A pasta local MATERIAL DE APOIO foi inventariada. Foram consultadas por extração de texto as três primeiras páginas de EST_DESC.pdf (7 páginas) e APOSTILA REGRESSÃO.pdf (19 páginas), esta de Silvana Lages Ribeiro Garcia e Helio Garcia Leite, como apoio à sequência de conceitos. Não se reproduziram tabelas ou textos desses PDFs. A extração do primeiro arquivo apresenta problemas de codificação. Não se realizou revisão de todos os PDFs/PPT. AULA_1.pdf, AULA_2.pdf e aula-8.pdf não estavam anexados a esta conversa e não foram encontrados com esses nomes no inventário; as obras de Freitas e Cargnelutti não foram utilizadas como se tivessem sido examinadas.

## Reuso do template

A classe foi copiada para este projeto independente. Preservados classe base, tipografia, paleta, títulos de unidade, equações numeradas, tabelas e caixas. O brasão foi copiado do mesmo template. Adaptações locais:

1. Capa com título longo e subtítulo visível; texto lateral reposicionado na faixa verde.
2. Cabeçalhos curtos e remoção de páginas vazias da configuração frente/verso.
3. Scripts externos com fonte monoespaçada de 9 pt, espaçamento simples e comentários em português.
4. `tcolorbox` carrega apenas as bibliotecas usadas (skins, breakable e listings); `most` exigia bibliotecas ausentes. Não foi necessária instalação extra.
5. BibLaTeX mantém autor-data, com backend BibTeX disponível; o original usava Biber.

## Distribuição e conteúdo

Planejamento: apresentação e sumário 3–4 páginas; unidades 1–7 em torno de 4–6 páginas cada; gabarito e referências 4–5 páginas. A extensão final consta de VALIDACAO.md.

Cada capítulo termina com exercícios e script correspondente. O gerador dos dados e executor geral são auxiliares fora do corpo. Usam-se simulações porque não havia uma base temática disponível que atendesse a todos os delineamentos propostos.

Bases observacionais de aves e água, dados pareados e experimentos de decomposição permanecem distintos. Mantêm-se as questões riqueza–clima e diversidade–topografia; contagens são discutidas sem impor regressão normal inadequada. Ambientes observados não são apresentados como tratamentos casualizados.

## Fontes bibliográficas

Metadados de Quinn e Keough (2002) verificados em catálogo editorial Cambridge; declaração ASA (2016) e DOI; protocolo de Zuur, Ieno e Elphick (2010) em resultado da editora Wiley; documentação oficial do R para t.test, TukeyHSD e introdução ao R. Somente essas fontes verificadas foram incorporadas ao .bib. Não foram inventadas edições, páginas ou identificadores das demais obras sugeridas.
