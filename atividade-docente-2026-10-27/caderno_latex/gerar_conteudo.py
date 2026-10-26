"""Gera o roteiro LaTeX e a inclusão integral do script sem duplicar o código R."""
from pathlib import Path
import re

root = Path(__file__).resolve().parent
atividade = root.parent

def escapar(s):
    mapa = {'\\': r'\textbackslash{}', '&': r'\&', '%': r'\%', '$': r'\$',
            '#': r'\#', '_': r'\_', '{': r'\{', '}': r'\}',
            '~': r'\textasciitilde{}', '^': r'\textasciicircum{}',
            'μ': r'\ensuremath{\mu}', 'β': r'\ensuremath{\beta}',
            'α': r'\ensuremath{\alpha}', 'η': r'\ensuremath{\eta}',
            'ω': r'\ensuremath{\omega}', '≈': r'\ensuremath{\approx}',
            '≤': r'\ensuremath{\leq}', '≥': r'\ensuremath{\geq}',
            '×': r'\ensuremath{\times}', '→': r'\ensuremath{\rightarrow}',
            '−': '-', '–': '--', '—': '---', '²': r'\textsuperscript{2}',
            '⁻': r'\textsuperscript{-}', '⁷': r'\textsuperscript{7}',
            '⁶': r'\textsuperscript{6}', 'Ĥ': r'\ensuremath{\widehat H}'}
    return ''.join(mapa.get(c, c) for c in s)

def inline(s):
    partes = re.split(r'(\*\*.+?\*\*|`[^`]+`)', s)
    result = []
    for p in partes:
        if p.startswith('**') and p.endswith('**'):
            result.append(r'\textbf{' + escapar(p[2:-2]) + '}')
        elif p.startswith('`') and p.endswith('`'):
            result.append(r'\texttt{' + escapar(p[1:-1]) + '}')
        else:
            result.append(escapar(p))
    return ''.join(result)

md = (atividade / 'ROTEIRO_DOCENTE.md').read_text(encoding='utf-8').splitlines()
out = [r'\chapter{Roteiro e atividades para discussão}',
       'Os blocos citados nesta parte correspondem às seções numeradas do script R. '
       'As respostas esperadas apoiam a condução docente e a discussão coletiva.']
i = 0
ambiente = None
def fechar():
    global ambiente
    if ambiente:
        out.append(r'\end{' + ambiente + '}')
        ambiente = None

while i < len(md):
    line = md[i].strip()
    if line.startswith('# '):
        i += 1
        continue
    if not line:
        fechar(); out.append(''); i += 1; continue
    if line.startswith('## '):
        fechar(); out.append(r'\section{' + inline(line[3:]) + '}')
        i += 1; continue
    if line.startswith('|'):
        fechar(); linhas=[]
        while i < len(md) and md[i].strip().startswith('|'):
            cells=[x.strip() for x in md[i].strip().strip('|').split('|')]
            if not all(re.fullmatch(r'[:\- ]+', x) for x in cells): linhas.append(cells)
            i += 1
        nc=len(linhas[0]); larguras = {3:[.28,.38,.24],4:[.27,.23,.18,.20]}.get(nc,[.88/nc]*nc)
        out += [r'\begin{table}[H]\centering\small',
                r'\begin{tabular}{' + ''.join('p{'+str(w)+r'\linewidth}' for w in larguras) + '}',r'\toprule']
        for k,row in enumerate(linhas):
            out.append(' & '.join(inline(x) for x in row)+r'\\')
            if k==0:out.append(r'\midrule')
        out += [r'\bottomrule\end{tabular}\end{table}']; continue
    m=re.match(r'^(\d+)\.\s+(.*)$',line)
    if line.startswith('- ') or m:
        tipo='enumerate' if m else 'itemize'
        if ambiente != tipo:
            fechar(); ambiente=tipo; out.append(r'\begin{'+tipo+'}')
        out.append(r'\item '+inline(m.group(2) if m else line[2:]));i+=1;continue
    fechar();out.append(inline(line)); i+=1
fechar()
(root/'roteiro.tex').write_text('\n'.join(out)+'\n',encoding='utf-8')

linhas=(atividade/'atividade_docente.R').read_text(encoding='utf-8').splitlines()
marcas=[(i+1,int(m.group(1))) for i,l in enumerate(linhas)
        if (m:=re.match(r'^# (\d+)\.',l))]
titulos={0:'Configuração e funções de apoio',1:'Auditoria dos dados',2:'Exploração visual',
3:'Hipóteses, somas de quadrados e teste F',4:'Pressupostos e sensibilidade',
5:'Teste de randomização',6:'Tukey e médias com intervalos',7:'Exploração da base de aves',
8:'Regressão simples e intervalos',9:'Regressão múltipla e testes parciais',
10:'Associações condicionais e robustez',11:'Influência e previsão',
12:'Extensão em blocos casualizados',13:'Síntese e exportação do relatório'}
partes=[]
for j,(inicio,numero) in enumerate(marcas):
    first=1 if j==0 else inicio
    last=marcas[j+1][0]-1 if j+1<len(marcas) else len(linhas)
    partes.append((numero,first,last))
assert sum(b-a+1 for _,a,b in partes)==len(linhas)
assert all(partes[j][2]+1==partes[j+1][1] for j in range(len(partes)-1))
out=[r'\chapter{Script R integral e comentado}\label{ap:script}',
'Este apêndice incorpora diretamente o arquivo principal, sem transcrever ou resumir '
'seus comandos. A numeração à esquerda é contínua e coincide com o arquivo executável. '
'As linhas iniciais de identificação e todas as funções de exportação estão incluídas.',
r'\begin{atencao}Execute primeiro o bloco 0. Os demais blocos utilizam as funções e os objetos '
r'definidos anteriormente. Para executar o código, utilize o arquivo \texttt{.R}; as quebras '
r'visuais de linhas longas no PDF não alteram o arquivo original.\end{atencao}',
r'\begin{longtable}{p{.12\linewidth}p{.60\linewidth}p{.18\linewidth}}',
r'\toprule Bloco & Conteúdo & Linhas\\\midrule\endhead']
for num,a,b in partes:
    out.append(f'{num} & {titulos[num]} & {a}--{b}'+r'\\')
out += [r'\bottomrule\end{longtable}', r'\clearpage']
for num,a,b in partes:
    out += [r'\section{Bloco '+str(num)+': '+titulos[num]+'}',
            r'\label{cod:bloco'+str(num)+'}',
            r'\codigo{'+str(a)+'}{'+str(b)+'}']
(root/'script_integral.tex').write_text('\n'.join(out)+'\n',encoding='utf-8')
(root/'cobertura_script.txt').write_text(
    f'Script: {len(linhas)} linhas.\nIncluidas: '+str(sum(b-a+1 for _,a,b in partes))+
    '\nIntervalos consecutivos, sem lacunas ou duplicacoes.\n'+
    '\n'.join(f'Bloco {n}: {a}-{b}' for n,a,b in partes)+'\n',encoding='utf-8')
print('Roteiro gerado; script integral:', len(linhas), 'linhas em',len(partes),'blocos.')
