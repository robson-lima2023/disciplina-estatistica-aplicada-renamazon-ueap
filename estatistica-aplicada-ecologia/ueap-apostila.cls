\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ueap-apostila}[2026/06/05 Template institucional UEAP para apostilas]

\LoadClass[11pt,a4paper,openany]{book}

%------------------------------------------------
% PACOTES
%------------------------------------------------
\RequirePackage{iftex}
\RequirePackage[T1]{fontenc}

\ifPDFTeX
\RequirePackage[utf8]{inputenc}
\fi

\RequirePackage{lmodern}
\RequirePackage[portuguese]{babel}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{setspace}
\RequirePackage{tikz}

\IfFileExists{microtype.sty}{
	\RequirePackage{microtype}
}{}

\RequirePackage{titlesec}
\RequirePackage{titletoc}
%------------------------------------------------
% SUMÁRIO PROFISSIONAL
%------------------------------------------------
\RequirePackage{tocloft}

\renewcommand{\contentsname}{Sumário}

% Título do sumário
\renewcommand{\cfttoctitlefont}{
	\Huge\bfseries\color{UEAPDarkBlue}
}

\renewcommand{\cftaftertoctitle}{
	\par\vspace{0.3cm}
	{\color{UEAPGold}\rule{0.65\textwidth}{1.2pt}}
	\vspace{0.8cm}
}

% Capítulos no sumário
\renewcommand{\cftchapfont}{
	\bfseries\color{UEAPDarkBlue}
}

\renewcommand{\cftchappagefont}{
	\bfseries\color{UEAPDarkBlue}
}

\renewcommand{\cftchapleader}{
	\cftdotfill{\cftdotsep}
}

\setlength{\cftbeforechapskip}{0.55em}

% Seções no sumário
\renewcommand{\cftsecfont}{
	\color{UEAPDarkBlue}
}

\renewcommand{\cftsecpagefont}{
	\color{UEAPDarkBlue}
}

\setlength{\cftbeforesecskip}{0.15em}
\setlength{\cftsecindent}{1.2em}
\setlength{\cftsecnumwidth}{2.6em}

% Subseções no sumário
\renewcommand{\cftsubsecfont}{
	\color{UEAPGray}
}

\renewcommand{\cftsubsecpagefont}{
	\color{UEAPGray}
}

\setlength{\cftsubsecindent}{3.8em}
\setlength{\cftsubsecnumwidth}{3.2em}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{hyperref}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{array}
\RequirePackage{amsmath,amssymb}
\RequirePackage{enumitem}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable}
\RequirePackage{listings}
\RequirePackage{caption}
\IfFileExists{fontawesome5.sty}{
	\RequirePackage{fontawesome5}
}{}

\IfFileExists{academicons.sty}{
	\RequirePackage{academicons}
}{}
%------------------------------------------------
% GEOMETRIA
%------------------------------------------------
\geometry{
	left=2.2cm,
	right=2.0cm,
	top=2.2cm,
	bottom=2.0cm,
	headheight=15pt
}

\onehalfspacing
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.55em}
\setlength{\emergencystretch}{3em}

%------------------------------------------------
% CORES INSTITUCIONAIS
%------------------------------------------------
\definecolor{UEAPGreen}{RGB}{0,102,51}
\definecolor{UEAPDarkGreen}{RGB}{0,70,40}
\definecolor{UEAPGold}{RGB}{212,175,55}
\definecolor{UEAPBlue}{RGB}{0,76,153}
\definecolor{UEAPDarkBlue}{RGB}{0,45,90}
\definecolor{UEAPGray}{RGB}{60,60,60}
\definecolor{UEAPLightGray}{RGB}{245,247,248}
\definecolor{UEAPCodeBg}{RGB}{248,248,248}
\definecolor{UEAPRed}{RGB}{160,40,40}

%------------------------------------------------
% LINKS
%------------------------------------------------
\hypersetup{
	colorlinks=true,
	linkcolor=UEAPDarkGreen,
	citecolor=UEAPBlue,
	urlcolor=UEAPBlue,
	filecolor=UEAPBlue
}

%------------------------------------------------
% COMANDOS DE METADADOS
%------------------------------------------------
\newcommand{\instituicao}[1]{\def\@instituicao{#1}}
\newcommand{\curso}[1]{\def\@curso{#1}}
\newcommand{\programa}[1]{\def\@programa{#1}}
\newcommand{\disciplina}[1]{\def\@disciplina{#1}}
\newcommand{\subtitulo}[1]{\def\@subtitulo{#1}}
\newcommand{\autor}[1]{\def\@autor{#1}}
\newcommand{\emailautor}[1]{\def\@emailautor{#1}}
\newcommand{\githubautor}[1]{\def\@githubautor{#1}}
\newcommand{\orcidautor}[1]{\def\@orcidautor{#1}}
\newcommand{\localano}[1]{\def\@localano{#1}}
\newcommand{\versao}[1]{\def\@versao{#1}}
\newcommand{\logoueap}[1]{\def\@logoueap{#1}}

\instituicao{Universidade do Estado do Amapá}
\curso{}
\programa{}
\disciplina{}
\subtitulo{}
\autor{}
\emailautor{}
\githubautor{}
\orcidautor{}
\localano{Macapá, Amapá}
\versao{Versão 1.0}
\logoueap{Brasao_UEAP.png}

%------------------------------------------------
% CABEÇALHO E RODAPÉ
%------------------------------------------------
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\small\textcolor{UEAPDarkGreen}{\@disciplina}}
\fancyhead[R]{\small\textcolor{UEAPDarkGreen}{\nouppercase{\leftmark}}}
\fancyfoot[L]{\small\textcolor{UEAPGray}{\@autor}}
\fancyfoot[R]{\small\textcolor{UEAPGray}{Página \thepage\ de \pageref{LastPage}}}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.2pt}
\raggedbottom
%------------------------------------------------
% TÍTULOS
%------------------------------------------------
\titleformat{\chapter}[display]
{\normalfont\bfseries\color{UEAPDarkGreen}}
{\Large UNIDADE \thechapter}
{0.3cm}
{\fontsize{24}{28}\selectfont}
[\vspace{0.15cm}\titlerule]

\titleformat{\section}
{\Large\bfseries\color{UEAPDarkBlue}}
{\thesection}{0.7em}{}

\titleformat{\subsection}
{\large\bfseries\color{UEAPDarkGreen}}
{\thesubsection}{0.7em}{}


%------------------------------------------------
% CAPA
%------------------------------------------------
\newcommand{\capaueap}{
	\begin{titlepage}
		\thispagestyle{empty}
		
		% Faixa vertical lateral
		\begin{tikzpicture}[remember picture,overlay]
			% faixa verde principal
			\fill[UEAPDarkGreen]
			(current page.north west)
			rectangle
			([xshift=1.05cm]current page.south west);
			
			% filete dourado
			\fill[UEAPGold]
			([xshift=1.05cm]current page.north west)
			rectangle
			([xshift=1.15cm]current page.south west);
			
			% texto institucional centralizado na faixa
			\node[
			rotate=90,
			anchor=center,
			text=white,
			font=\bfseries\scriptsize,
			align=center
			] at ([xshift=0.50cm]current page.center)
			{UEAP \quad | \quad MATERIAL DIDÁTICO};
		\end{tikzpicture}
		
		\hspace*{1.2cm}
		\begin{minipage}{0.88\textwidth}
			
			\noindent
			\begin{minipage}[t]{0.66\textwidth}
				\vspace{0pt}
				{\fontsize{16}{18}\selectfont
					\bfseries
					\textcolor{UEAPDarkGreen}{\@instituicao}
				}\\[0.18cm]
				{\small \@curso}\\[0.06cm]
				{\small \@programa}\\[0.06cm]
				{\small Disciplina: \@disciplina}
			\end{minipage}
			\hfill
			\begin{minipage}[t]{0.26\textwidth}
				\vspace{0pt}
				\raggedleft
				\IfFileExists{\@logoueap}{
					\includegraphics[width=3.8cm]{\@logoueap}
				}{
					\fbox{\Large UEAP}
				}
			\end{minipage}
			
			\vspace{2.4cm}
			
			\begin{center}
				
				{\small\bfseries\textcolor{UEAPGold}{MATERIAL DE APOIO DIDÁTICO}}\\[0.35cm]
				
				{\fontsize{24}{28}\selectfont
					\bfseries
					\textcolor{UEAPDarkBlue}{\@title}
				}\\[0.85cm]
				
				\rule{0.78\textwidth}{1.2pt}\\[0.45cm]
				
				{\large\textbf{\@autor}}\\[0.25cm]
				
				{\large
					\textcolor{UEAPBlue}{\faEnvelope}
					\quad
					\href{mailto:\@emailautor}{\textcolor{UEAPBlue}{\@emailautor}}
				}\\[0.18cm]
				
				{\large
					\textcolor{black}{\faGithub}
					\quad
					\href{\@githubautor}{\textcolor{UEAPBlue}{\@githubautor}}
				}\\[0.18cm]
				
				{\large
					\href{https://orcid.org/\@orcidautor}{
						\includegraphics[height=0.38cm]{orcid.png}
					}
					\quad
					\href{https://orcid.org/\@orcidautor}{
						\textcolor{UEAPBlue}{https://orcid.org/\@orcidautor}
					}
				}\\[0.45cm]
				
				{\normalsize \@versao}
				
			\end{center}
			
			\vfill
			
			\begin{tcolorbox}[
				colback=UEAPLightGray,
				colframe=UEAPDarkGreen,
				boxrule=0.8pt,
				arc=2mm,
				left=8pt,
				right=8pt,
				top=8pt,
				bottom=8pt
				]
				\textbf{Objetivo do material.} Esta apostila foi elaborada como material de apoio didático para disciplinas de graduação, pós-graduação, cursos de extensão e atividades de formação acadêmica da Universidade do Estado do Amapá.
			\end{tcolorbox}
			
			\vfill
			
			\begin{center}
				{\large \@localano}
			\end{center}
			
		\end{minipage}
		
	\end{titlepage}
}

%------------------------------------------------
% PÁGINA INSTITUCIONAL
%------------------------------------------------
\newcommand{\paginainstitucional}{
	\thispagestyle{empty}
	
	\begin{center}
		
		\IfFileExists{\@logoueap}{
			\includegraphics[width=2.8cm]{\@logoueap}
		}{
			\fbox{\Large UEAP}
		}
		
		\vspace{0.6cm}
		
		{\Large\bfseries\textcolor{UEAPDarkGreen}{\@instituicao}}\\[0.25cm]
		{\normalsize \@curso}\\
		{\normalsize \@programa}
		
		\vspace{1.0cm}
		
		\rule{0.75\textwidth}{0.8pt}\\[0.35cm]
		{\Large\bfseries\textcolor{UEAPDarkBlue}{Material Didático Institucional}}\\[0.25cm]
		\rule{0.75\textwidth}{0.8pt}
		
		\vspace{1.0cm}
		
		\begin{tabular}{>{\bfseries\color{UEAPDarkGreen}}p{3.8cm}p{9.2cm}}
			Título: & \@title\\[0.15cm]
			Disciplina: & \@disciplina\\[0.15cm]
			Curso: & \@curso\\[0.15cm]
			Programa: & \@programa\\[0.15cm]
			Autor: & \@autor\\[0.15cm]
			E-mail: & \href{mailto:\@emailautor}{\textcolor{UEAPBlue}{\@emailautor}}\\[0.15cm]
			GitHub: & \href{\@githubautor}{\textcolor{UEAPBlue}{\@githubautor}}\\[0.15cm]
			ORCID: & \href{https://orcid.org/\@orcidautor}{\textcolor{UEAPBlue}{https://orcid.org/\@orcidautor}}\\[0.15cm]
			Versão: & \@versao\\[0.15cm]
			Local e ano: & \@localano\\
		\end{tabular}
		
		\vfill
		
		\begin{tcolorbox}[
			colback=white,
			colframe=UEAPDarkGreen,
			boxrule=0.5pt,
			arc=1mm,
			width=0.86\textwidth,
			left=8pt,
			right=8pt,
			top=7pt,
			bottom=7pt
			]
			\small
			Este documento integra o conjunto de materiais didáticos institucionais produzidos para apoiar atividades de ensino, pesquisa, extensão e formação acadêmica vinculadas à Universidade do Estado do Amapá.
		\end{tcolorbox}
		
		\vspace{0.6cm}
		
		{\small\textcolor{UEAPGray}{Documento preparado em \LaTeX{} com o template institucional UEAP para apostilas.}}
		
	\end{center}
	
	\clearpage
}

%------------------------------------------------
% CAIXAS DIDÁTICAS
%------------------------------------------------
%------------------------------------------------
% CAIXAS DIDÁTICAS ESTILO SPRINGER
%------------------------------------------------

\newtcolorbox{conceito}[1][]{
	enhanced,
	breakable,
	colback=UEAPLightGray,
	colframe=UEAPBlue,
	boxrule=0pt,
	leftrule=3pt,
	arc=1mm,
	left=8pt,
	right=8pt,
	top=7pt,
	bottom=7pt,
	title={\faBook\quad Conceito},
	fonttitle=\bfseries\color{UEAPBlue},
	coltitle=UEAPBlue,
	attach boxed title to top left={xshift=6pt,yshift=-2mm},
	boxed title style={
		colback=white,
		colframe=white,
		boxrule=0pt
	},
	#1
}

\newtcolorbox{atencao}[1][]{
	enhanced,
	breakable,
	colback=red!4,
	colframe=UEAPRed,
	boxrule=0pt,
	leftrule=3pt,
	arc=1mm,
	left=8pt,
	right=8pt,
	top=7pt,
	bottom=7pt,
	title={\faExclamationTriangle\quad Atenção},
	fonttitle=\bfseries\color{UEAPRed},
	coltitle=UEAPRed,
	attach boxed title to top left={xshift=6pt,yshift=-2mm},
	boxed title style={
		colback=white,
		colframe=white,
		boxrule=0pt
	},
	#1
}

\newtcolorbox{exemplo}[1][]{
	enhanced,
	breakable,
	colback=green!4,
	colframe=UEAPGreen,
	boxrule=0pt,
	leftrule=3pt,
	arc=1mm,
	left=8pt,
	right=8pt,
	top=7pt,
	bottom=7pt,
	title={\faFlask\quad Exemplo aplicado},
	fonttitle=\bfseries\color{UEAPGreen},
	coltitle=UEAPGreen,
	attach boxed title to top left={xshift=6pt,yshift=-2mm},
	boxed title style={
		colback=white,
		colframe=white,
		boxrule=0pt
	},
	#1
}

\newtcolorbox{dica}[1][]{
	enhanced,
	breakable,
	colback=yellow!8,
	colframe=UEAPGold,
	boxrule=0pt,
	leftrule=3pt,
	arc=1mm,
	left=8pt,
	right=8pt,
	top=7pt,
	bottom=7pt,
	title={\faLightbulb\quad Dica},
	fonttitle=\bfseries\color{UEAPGold},
	coltitle=UEAPGold,
	attach boxed title to top left={xshift=6pt,yshift=-2mm},
	boxed title style={
		colback=white,
		colframe=white,
		boxrule=0pt
	},
	#1
}

\newtcolorbox{equationbox}[1][]{
	enhanced,
	breakable,
	colback=UEAPLightGray,
	colframe=UEAPDarkGreen,
	boxrule=0pt,
	leftrule=3pt,
	arc=1mm,
	left=8pt,
	right=8pt,
	top=7pt,
	bottom=7pt,
	#1
}

\newtcolorbox{objetivos}[1][]{
	enhanced,
	breakable,
	colback=UEAPLightGray,
	colframe=UEAPDarkBlue,
	boxrule=0pt,
	leftrule=3pt,
	arc=1mm,
	left=8pt,
	right=8pt,
	top=7pt,
	bottom=7pt,
	title={\faBullseye\quad Objetivos da unidade},
	fonttitle=\bfseries\color{UEAPDarkBlue},
	coltitle=UEAPDarkBlue,
	attach boxed title to top left={xshift=6pt,yshift=-2mm},
	boxed title style={
		colback=white,
		colframe=white,
		boxrule=0pt
	},
	#1
}

\newtcolorbox{exercicios}[1][]{
	enhanced,
	breakable,
	colback=white,
	colframe=UEAPDarkGreen,
	boxrule=0pt,
	leftrule=3pt,
	arc=1mm,
	left=8pt,
	right=8pt,
	top=7pt,
	bottom=7pt,
	title={\faPen\quad Exercícios de fixação},
	fonttitle=\bfseries\color{UEAPDarkGreen},
	coltitle=UEAPDarkGreen,
	attach boxed title to top left={xshift=6pt,yshift=-2mm},
	boxed title style={
		colback=white,
		colframe=white,
		boxrule=0pt
	},
	#1
}

%------------------------------------------------
% CAIXA PARA QUESTÕES / EXERCÍCIOS
%------------------------------------------------

\newcounter{questao}

\newenvironment{questao}
{
	\refstepcounter{questao}
	\begin{tcolorbox}[
		enhanced,
		breakable,
		colback=white,
		colframe=UEAPDarkBlue,
		colbacktitle=UEAPDarkBlue,
		coltitle=white,
		boxrule=0.5pt,
		leftrule=3pt,
		arc=1mm,
		left=8pt,
		right=8pt,
		top=7pt,
		bottom=7pt,
		title={\faPen\quad Questão \thequestao},
		fonttitle=\bfseries
		]
	}
	{
	\end{tcolorbox}
}

%------------------------------------------------
% CÓDIGOS R - ESTILO APOSTILA UEAP
%------------------------------------------------

\RequirePackage{listings}
\tcbuselibrary{listings,skins,breakable}

% Fonte moderna para scripts R
\ifXeTeX
\RequirePackage{fontspec}
\IfFontExistsTF{Cascadia Code}{
	\newfontfamily\RCodeFont{Cascadia Code}
}{
	\IfFontExistsTF{Cascadia Mono}{
		\newfontfamily\RCodeFont{Cascadia Mono}
	}{
		\IfFontExistsTF{Consolas}{
			\newfontfamily\RCodeFont{Consolas}
		}{
			\newfontfamily\RCodeFont{Latin Modern Mono}
		}
	}
}
\else
\newcommand{\RCodeFont}{\ttfamily}
\fi

% Linguagem R personalizada
\lstdefinelanguage{Rcustom}{
	language=R,
	morekeywords={
		library,data.frame,as.matrix,melt,ggplot,aes,geom_point,labs,
		theme,theme_bw,theme_classic,tema_livro,decostand,prcomp,
		summary,biplot,scale,center,TRUE,FALSE
	},
	sensitive=true,
	morecomment=[l]{\#},
	morestring=[b]",
	morestring=[b]'
}

% Estilo visual do código R
\lstdefinestyle{ueapRstyle}{
	language=Rcustom,
	basicstyle=\RCodeFont\fontsize{11.5}{14}\selectfont,
	keywordstyle=\bfseries\color{UEAPDarkBlue},
	commentstyle=\color{UEAPGreen},
	stringstyle=\color{UEAPRed},
	identifierstyle=\color{black},
	numbers=none,
	showstringspaces=false,
	showspaces=false,
	showtabs=false,
	tabsize=2,
	breaklines=true,
	breakatwhitespace=false,
	keepspaces=true,
	columns=fullflexible,
	frame=none,
	backgroundcolor=\color{UEAPCodeBg}
}

% Caixa para importar scripts R externos
\newcommand{\rscriptfile}[1]{%
	\begin{tcolorbox}[
		enhanced,
		breakable,
		colback=UEAPCodeBg,
		colframe=UEAPDarkBlue,
		colbacktitle=white,
		boxrule=0.5pt,
		leftrule=3pt,
		arc=1mm,
		left=7pt,
		right=7pt,
		top=7pt,
		bottom=7pt,
		title={\faCode\quad R Script},
		fonttitle=\bfseries,
		coltitle=UEAPDarkBlue
		]
		\lstinputlisting[style=ueapRstyle]{#1}
	\end{tcolorbox}
}

% Ambiente rcode opcional, caso ainda exista no .tex
\newtcblisting{rcode}{
	enhanced,
	breakable,
	listing engine=listings,
	listing only,
	colback=UEAPCodeBg,
	colframe=UEAPDarkBlue,
	colbacktitle=white,
	boxrule=0.5pt,
	leftrule=3pt,
	arc=1mm,
	left=7pt,
	right=7pt,
	top=7pt,
	bottom=7pt,
	title={\faCode\quad R Script},
	fonttitle=\bfseries,
	coltitle=UEAPDarkBlue,
	listing options={
		style=ueapRstyle
	}
}

%------------------------------------------------
% FIGURAS, TABELAS E LISTAS
%------------------------------------------------
\captionsetup{
	font=small,
	labelfont=bf,
	labelsep=period
}

\setlist[itemize]{leftmargin=*,topsep=3pt,itemsep=2pt}
\setlist[enumerate]{leftmargin=*,topsep=3pt,itemsep=2pt}

%------------------------------------------------
% COMANDOS ÚTEIS
%------------------------------------------------
\newcommand{\doilink}[1]{\href{https://doi.org/#1}{\textcolor{UEAPBlue}{https://doi.org/#1}}}
\newcommand{\weblink}[2]{\href{#1}{\textcolor{UEAPBlue}{#2}}}

\endinput
