%% htldon.cls -- document class for diploma theses
%% HTL Donaustadt, Department of Information Technology
%%
%% The thesis is written in German, so all typeset text and every command
%% name is German. Only the comments are English.
%%
%% Copyright (C) 2026 Peter Oettl
%% License: MIT -- see LICENSE

\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{htldon}[2026/08/12 v1.0 Diplomarbeit HTL Donaustadt IT]

\RequirePackage{etoolbox}

% =====================================================================
% Class options
% =====================================================================
\newcommand*{\htl@sprache}{ngerman}
\DeclareOption{deutsch}{\renewcommand*{\htl@sprache}{ngerman}}
\DeclareOption{englisch}{\renewcommand*{\htl@sprache}{english}}

\newcommand*{\htl@bibstyle}{ieee}
\DeclareOption{ieee}{\renewcommand*{\htl@bibstyle}{ieee}}
\DeclareOption{harvard}{\renewcommand*{\htl@bibstyle}{authoryear}}

\newcommand*{\htl@schrift}{lato}
\DeclareOption{lato}{\renewcommand*{\htl@schrift}{lato}}
\DeclareOption{inter}{\renewcommand*{\htl@schrift}{inter}}
\DeclareOption{carlito}{\renewcommand*{\htl@schrift}{carlito}}
\DeclareOption{aptos}{\renewcommand*{\htl@schrift}{aptos}}

\newif\ifhtl@entwurf
\DeclareOption{entwurf}{\htl@entwurftrue}

\DeclareOption*{%
  \ClassError{htldon}{Unbekannte Option '\CurrentOption'}%
    {Erlaubt sind: deutsch, englisch, ieee, harvard,
     lato, inter, carlito, aptos, entwurf.}%
}
\ProcessOptions\relax

\LoadClass[%
  a4paper,
  fontsize=11pt,
  twoside=false,
  open=any,
  parskip=half,
  numbers=noendperiod,
  listof=totoc,
  toc=chapterentrydotfill,
]{scrreprt}

% =====================================================================
% Language -- \htl@txt{german}{english}
% =====================================================================
\RequirePackage[\htl@sprache]{babel}
% Resolved once so that \htl@txt stays fully expandable -- otherwise hyperref
% complains while generating the bookmarks.
\ifdefstring{\htl@sprache}{english}
  {\newcommand*{\htl@txt}[2]{#2}}
  {\newcommand*{\htl@txt}[2]{#1}}

% =====================================================================
% Typeface
% =====================================================================
\RequirePackage{iftex}
\ifdefstring{\htl@schrift}{aptos}{%
  \ifPDFTeX
    \ClassError{htldon}{Option 'aptos' braucht LuaLaTeX oder XeLaTeX}%
      {Kompiliere mit lualatex, oder nimm die Option 'lato' (Standard).}%
  \fi
  \RequirePackage{fontspec}
  \IfFontExistsTF{Aptos}{%
    \setsansfont{Aptos}%
    \setmainfont{Aptos}%
    \renewcommand*{\familydefault}{\sfdefault}%
  }{%
    \ClassError{htldon}{Schriftart 'Aptos' ist nicht installiert}%
      {Aptos kommt mit Microsoft 365. Ohne installierte Schrift bitte die
       Option 'lato' (Standard), 'inter' oder 'carlito' verwenden.}%
  }%
}{%
  \RequirePackage[T1]{fontenc}
  % 'default' sets \familydefault, the second option also sets \sfdefault --
  % without it \textsf falls back to Computer Modern.
  \ifdefstring{\htl@schrift}{inter}{\RequirePackage[default,sfdefault]{inter}}{}%
  \ifdefstring{\htl@schrift}{carlito}{\RequirePackage[default,sfdefault]{carlito}}{}%
  \ifdefstring{\htl@schrift}{lato}{\RequirePackage[default,defaultsans]{lato}}{}%
}
\RequirePackage[scaled=0.94]{inconsolata}
\RequirePackage{microtype}
\linespread{1.15}

% =====================================================================
% Page layout -- taken 1:1 from Vorlage_Diplomarbeit_2025_v6.dotx.
%   Word sets left 1701, right 1134, top 1418, bottom 1134 twips there,
%   with header and footer at 737 -- so 30 / 20 / 25 / 20 mm at 13 mm.
%   That makes the text block 160 mm wide.
%   The earlier values came from measuring a PDF and were 5 mm off at
%   the bottom.
% Header: geometry places it inside the top margin, so its top edge sits
%   at top - headsep - headheight = 25 - 5 - 7 = 13 mm.
% =====================================================================
\RequirePackage{geometry}
\geometry{
  a4paper,
  left=30mm, right=20mm,
  top=25mm, bottom=20mm,
  headheight=7mm, headsep=5mm,
  footskip=12mm,
}

% =====================================================================
% Colours -- htlblau is #1A6CA0
% =====================================================================
\RequirePackage{xcolor}
\definecolor{htlblau}{RGB}{26,108,160}
\definecolor{htlgrau}{RGB}{89,89,89}

% =====================================================================
% Metadata
% =====================================================================
\newcommand*{\htl@titel}{\ClassWarning{htldon}{\string\titel\space fehlt}}
\newcommand*{\htl@kurztitel}{}
\newcommand*{\htl@projektlogo}{}
\newcommand*{\htl@schuljahr}{}
\newcommand*{\htl@abteilung}{Informationstechnologie}
\newcommand*{\htl@klasse}{}
\newcommand*{\htl@ort}{Wien}
\newcommand*{\htl@abgabedatum}{\today}
\newcommand*{\htl@logo}{images/logo-htl-donaustadt.png}
\newcommand*{\htl@schuladresse}{Donaustadtstraße 45\\1220 Wien}

\newcommand{\titel}[1]{\gdef\htl@titel{#1}}
\newcommand{\kurztitel}[1]{\gdef\htl@kurztitel{#1}}
\newcommand{\projektlogo}[1]{\gdef\htl@projektlogo{#1}}
\newcommand{\schuljahr}[1]{\gdef\htl@schuljahr{#1}}
\newcommand{\abteilung}[1]{\gdef\htl@abteilung{#1}}
\newcommand{\klasse}[1]{\gdef\htl@klasse{#1}}
\newcommand{\ort}[1]{\gdef\htl@ort{#1}}
\newcommand{\abgabedatum}[1]{\gdef\htl@abgabedatum{#1}}
\newcommand{\schullogo}[1]{\gdef\htl@logo{#1}}

% --- Team ------------------------------------------------------------
% \teammitglied[short form]{SURNAME}{Given name}
% The short form ("M. Musterfrau") appears in the page header. Without the
% optional argument it is derived automatically. If the given name starts
% with a special character (Ö, Č, ...), pass the short form explicitly.
\ExplSyntaxOn
% First letter of the given name
\cs_new:Npn \htl_initial:n #1 { \tl_head:f {#1} }
\cs_set_eq:NN \htlInitial \htl_initial:n
% MUSTERFRAU -> Musterfrau (for the page header and the declaration)
\tl_new:N \l__htl_name_tl
\cs_new_protected:Npn \htl_namecase:n #1
  {
    \tl_set:Nx \l__htl_name_tl { \text_lowercase:n {#1} }
    \exp_args:NV \text_titlecase:n \l__htl_name_tl
  }
\cs_set_eq:NN \htlNameCase \htl_namecase:n
\ExplSyntaxOff

\newcommand*{\htl@teamliste}{}
\newcounter{htl@teamzahl}
\newcommand{\teammitglied}[3][]{%
  \stepcounter{htl@teamzahl}%
  \ifblank{#1}%
    {\protected@edef\htl@tmp{\noexpand\htl@do@mitglied
       {\htlInitial{#3}.~\noexpand\htlNameCase{#2}}{#2}{#3}}}%
    {\protected@edef\htl@tmp{\noexpand\htl@do@mitglied{#1}{#2}{#3}}}%
  \expandafter\g@addto@macro\expandafter\htl@teamliste\expandafter{\htl@tmp}%
}

% --- Supervisors -----------------------------------------------------
% \betreuung[label on the title page]{Titel Vorname NACHNAME, Titel}
\newcommand*{\htl@betreuungliste}{}
\newcommand{\betreuung}[2][]{%
  \ifblank{#1}%
    {\protected@edef\htl@tmp{\noexpand\htl@do@betreuung
       {\htl@txt{Betreuer}{Supervisor}}{#2}}}%
    {\protected@edef\htl@tmp{\noexpand\htl@do@betreuung{#1}{#2}}}%
  \expandafter\g@addto@macro\expandafter\htl@betreuungliste\expandafter{\htl@tmp}%
}

% \alleautoren -> "M. Musterfrau, B. Beispiel, V. Vorlage"
% Robust on purpose: it ends up inside a mark, and the header code expands
% marks to compare them. \begingroup and \def do not survive that, so the
% command has to stay a single unexpandable token there.
\DeclareRobustCommand*{\alleautoren}{%
  \begingroup
    \def\htl@sep{}%
    \def\htl@do@mitglied##1##2##3{\htl@sep##1\def\htl@sep{, }}%
    \htl@teamliste
  \endgroup
}

% =====================================================================
% Header and footer
% =====================================================================
\RequirePackage{scrlayer-scrpage}

% Authorship changes per section, not just per chapter, and two authors can
% share a page. A plain \gdef cannot express that: the header is assembled at
% shipout, so the last value set on the page would win and the person who
% wrote the top half of it would vanish from the header.
%
% Marks solve it. \FirstMark and \LastMark are the first and last author
% declared on the page; when nobody switches, TeX makes both equal to the
% value carried over, so an ordinary page still shows the right person. Two
% sections sharing a page list both, which is what the department guideline
% asks for: "Haben mehrere Personen gemeinsam an einem Kapitel gearbeitet, so
% sind alle zu nennen", separated by commas.
%
% \TopMark is deliberately NOT consulted. It holds whoever was writing when
% the page began, and after a \chapter or a \clearpage that is the previous
% author, who contributed nothing to this page -- reading it would credit the
% whole team on the first page of every chapter.
%
% One case stays manual: if a section spills across a page break and the next
% author starts further down that same page, only the second one is listed.
% Word behaves the same way (its header takes the last section on the page),
% and the guideline's answer is the same -- name both by hand:
%   \abschnittsautor{A. Erste, B. Zweite}
\NewMarkClass{htlautor}

% Call directly AFTER \chapter or \section -- the value applies from there on.
\newcommand{\abschnittsautor}[1]{\InsertMark{htlautor}{#1}}

\ExplSyntaxOn
\tl_new:N \l__htl_autor_tl
\seq_new:N \l__htl_autoren_seq
% Marks are stored unexpanded, so \alleautoren has to be expanded here before
% two entries can be compared as strings.
\cs_new_protected:Npn \__htl_autor_add:n #1
  {
    \tl_set:Nx \l__htl_autor_tl {#1}
    \tl_if_empty:NF \l__htl_autor_tl
      {
        \seq_if_in:NVF \l__htl_autoren_seq \l__htl_autor_tl
          { \seq_put_right:NV \l__htl_autoren_seq \l__htl_autor_tl }
      }
  }
\cs_new_protected:Npn \htl_seitenautoren:
  {
    \seq_clear:N \l__htl_autoren_seq
    \__htl_autor_add:n { \FirstMark{htlautor} }
    \__htl_autor_add:n { \LastMark{htlautor} }
    \seq_use:Nn \l__htl_autoren_seq { ,~ }
  }
\cs_set_eq:NN \htl@abschnittsautor \htl_seitenautoren:
\ExplSyntaxOff

\pagestyle{scrheadings}
\clearpairofpagestyles
\ihead{\htl@kurztitel}
\ohead{\htl@abschnittsautor}
\ifoot{\htl@klasse}
\cfoot{\pagemark}
\ofoot{\htl@schuljahr}
\KOMAoptions{headsepline=0.4pt, footsepline=0.4pt}
\setkomafont{pageheadfoot}{\normalfont\small}
\setkomafont{pagenumber}{\normalfont\small}
\renewcommand*{\chapterpagestyle}{scrheadings}

% =====================================================================
% Headings: blue, UPPERCASE, bold, hanging indent
% =====================================================================
\setkomafont{chapter}{\color{htlblau}\bfseries\Large}
\setkomafont{section}{\color{htlblau}\bfseries\large}
\setkomafont{subsection}{\color{htlblau}\bfseries\normalsize}
\setkomafont{subsubsection}{\color{htlblau}\bfseries\normalsize}

\renewcommand{\chapterlinesformat}[3]{\@hangfrom{#2}{\MakeUppercase{#3}}}
\renewcommand*{\sectionlinesformat}[4]{\@hangfrom{\hskip #2#3}{\MakeUppercase{#4}}}

\renewcommand*{\chapterformat}{\makebox[1.6em][l]{\thechapter}}
\renewcommand*{\sectionformat}{\makebox[2.6em][l]{\thesection}}
\renewcommand*{\subsectionformat}{\makebox[3.4em][l]{\thesubsection}}
\renewcommand*{\subsubsectionformat}{\makebox[4.2em][l]{\thesubsubsection}}

\RedeclareSectionCommand[beforeskip=0pt, afterskip=1.2\baselineskip]{chapter}
\RedeclareSectionCommand[beforeskip=-1.6\baselineskip, afterskip=.5\baselineskip]{section}
\RedeclareSectionCommand[beforeskip=-1.3\baselineskip, afterskip=.4\baselineskip]{subsection}

\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}
\addtokomafont{chapterentry}{\normalfont\normalsize}

% =====================================================================
% Figures and tables
%   Caption below the figure, bold, centred: "Abb. 3: Titel"
%   Numbering runs continuously, not per chapter
%
%   "Abb." and "Tab." are prescribed by the department template, "Fig." and
%   "Tab." in English. Set at \begin{document}: babel redefines \figurename
%   there through \captionsngerman and would overwrite an assignment made in
%   the preamble.
% =====================================================================
\RequirePackage{graphicx}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{xltabular}
\RequirePackage{caption}
\captionsetup{font=small, labelfont=bf, textfont=bf,
              labelsep=colon, justification=centering, skip=8pt}
\AtBeginDocument{%
  \renewcommand*{\figurename}{\htl@txt{Abb.}{Fig.}}%
  \renewcommand*{\tablename}{Tab.}%
}

% The lists carry the label too: Word's list of figures reads
% "Abb. 1: Loeschen der gelben Markierung", not a bare "1". listformat is what
% goes inside \numberline, so the entry style below has to reserve room for
% the whole label rather than for a digit.
\DeclareCaptionListFormat{htlfigure}{\figurename~#2:}
\DeclareCaptionListFormat{htltable}{\tablename~#2:}
\captionsetup[figure]{listformat=htlfigure}
\captionsetup[table]{listformat=htltable}

% indent=0pt: the entries used to start 16.4pt inside the left margin, which
% put them out of line with every heading on the page.
\DeclareTOCStyleEntry[indent=0pt, numwidth=4.2em]{tocline}{figure}
\DeclareTOCStyleEntry[indent=0pt, numwidth=4.2em]{tocline}{table}
\DeclareCaptionListFormat{htlcode}{\lstlistingname~#2:}
\captionsetup[table]{position=top}
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\renewcommand*{\arraystretch}{1.3}

% =====================================================================
% Source code listings
% =====================================================================
\RequirePackage{listings}
\renewcommand*{\lstlistingname}{\htl@txt{Quellcode}{Source code}}
\renewcommand*{\lstlistlistingname}{\htl@txt{Quellcodeverzeichnis}{List of Source Code}}
% Deliberately not brand-coloured: a listing is quoted material, not a piece
% of the school's identity, and blue keywords next to blue headings made the
% page read as if the code were another heading.
\lstset{
  basicstyle=\ttfamily\footnotesize,
  keywordstyle=\bfseries,
  commentstyle=\itshape\color{htlgrau},
  stringstyle=\color{htlgrau},
  numbers=left, numberstyle=\tiny\color{htlgrau}, numbersep=8pt,
  frame=single, rulecolor=\color{htlgrau},
  breaklines=true, breakatwhitespace=true,
  showstringspaces=false, tabsize=2,
  captionpos=b,
  xleftmargin=16pt, framexleftmargin=16pt,
  numberbychapter=false,
}

% The source code list, brought into line with the other two: flush left, and
% with room for the whole "Quellcode 1:" label instead of a bare digit, which
% otherwise overprints the caption.
%
% \DeclareTOCStyleEntry, which does this for figures and tables, has no effect
% on lstlisting -- tocbasic keeps \scr@tso@lstlisting@indent at 1.5em whatever
% it is passed. \l@lstlisting itself is rebuilt at \begin{document}, so a
% plain \renewcommand in the preamble is taken back too. Hence the hook, and
% hence it living here rather than up with the other list settings.
% 6.2em covers the label, measured at 60.9pt in the 11pt text font.
\captionsetup[lstlisting]{listformat=htlcode}
% The entry itself is set where the list is printed, see \quellcodeverzeichnis.

% =====================================================================
% Abbreviations and bibliography
% =====================================================================
% nohyperlinks: otherwise every abbreviation NOT used in the text produces an
% unresolvable reference and with it a warning during the build.
\RequirePackage[nohyperlinks]{acronym}
\RequirePackage{csquotes}
\RequirePackage[backend=biber, style=\htl@bibstyle]{biblatex}

% =====================================================================
% Hyperref (load last)
% =====================================================================
\RequirePackage{hyperref}
\hypersetup{
  colorlinks=true,
  linkcolor=black, citecolor=black, filecolor=black,
  urlcolor=htlblau,
  bookmarksnumbered=true,
}
\RequirePackage{bookmark}
\urlstyle{same}
\AtBeginDocument{\hypersetup{pdftitle={\htl@titel}}}

\ifhtl@entwurf
  \RequirePackage{draftwatermark}
  \SetWatermarkText{\htl@txt{ENTWURF}{DRAFT}}
  \SetWatermarkScale{0.9}
  \SetWatermarkLightness{0.92}
\fi

% =====================================================================
% Title page
% =====================================================================
\newcommand{\titelblatt}{%
  \begin{titlepage}%
  \newgeometry{left=25mm, right=14.6mm, top=9.4mm, bottom=15mm}%
  \thispagestyle{empty}%
  \setlength{\parindent}{0pt}\setlength{\parskip}{0pt}%
  \linespread{1}\selectfont
  % --- Letterhead ---
  \noindent
  \begin{minipage}[b]{0.45\linewidth}
    \fontsize{8}{10.5}\selectfont
    \textbf{htl donaustadt}\\ \htl@schuladresse
  \end{minipage}\hfill
  \begin{minipage}[b]{0.5\linewidth}
    \raggedleft\includegraphics[width=55mm]{\htl@logo}
  \end{minipage}
  \par\vspace{4.7mm}
  \noindent\rule{\linewidth}{0.4pt}
  % --- Title ---
  \par\vspace{9.5mm}
  \begin{center}
    {\fontsize{20}{24}\selectfont\bfseries \htl@txt{DIPLOMARBEIT}{DIPLOMA THESIS}}\par
    \vspace{6.5mm}
    {\fontsize{18}{22}\selectfont\bfseries \htl@titel\par}
  \end{center}
  % --- Project logo (fixed height so the data block always sits the same) ---
  \ifdefempty{\htl@projektlogo}%
    {\par\vspace*{30mm}}%
    {\par\vspace{8mm}%
     \begin{center}%
       \includegraphics[height=96mm, width=\linewidth, keepaspectratio]{\htl@projektlogo}%
     \end{center}}%
  % --- Data block ---
  \par\vspace{10mm}
  \fontsize{12}{14.4}\selectfont
  \noindent\hspace*{12.9mm}%
  \begin{minipage}[t]{\dimexpr\linewidth-12.9mm\relax}
    \def\htl@zeile##1##2{%
      \par\noindent
      \makebox[44.6mm][l]{##1}%
      \parbox[t]{\dimexpr\linewidth-44.6mm\relax}{\raggedright ##2}%
      \par\vspace{4.3mm}}%
    \def\htl@erste{1}%
    \def\htl@do@mitglied##1##2##3{%
      \ifdefstring{\htl@erste}{1}%
        {\htl@zeile{\htl@txt{Projektteam:}{Project team:}}{##2 ##3}\def\htl@erste{0}}%
        {\htl@zeile{}{##2 ##3}}}%
    \htl@teamliste
    \def\htl@do@betreuung##1##2{\htl@zeile{##1:}{##2}}%
    \htl@betreuungliste
    \vspace{4.2mm}%
    \htl@zeile{\htl@txt{Schuljahr:}{School year:}}{\htl@schuljahr}%
    \htl@zeile{\htl@txt{Abteilung:}{Department:}}{\htl@abteilung}%
    \htl@zeile{\htl@txt{Klasse:}{Class:}}{\htl@klasse}%
  \end{minipage}
  \end{titlepage}%
  \restoregeometry
  \pagenumbering{gobble}%
  % Default for the page header until \abschnittsautor sets something else
  \abschnittsautor{\alleautoren}%
}

% =====================================================================
% Declaration of authorship
% =====================================================================
\newcommand{\htl@erklaerungstext}{%
  \htl@txt{%
    Hiermit erkläre ich, dass ich die vorliegende Diplomarbeit eigenständig
    und ohne unzulässige Hilfe verfasst habe. Alle verwendeten Quellen und
    Hilfsmittel sind vollständig und korrekt angegeben, und Inhalte, die aus
    anderen Werken übernommen wurden, sind entsprechend gekennzeichnet. Ich
    bestätige, dass diese Arbeit in dieser Form noch nicht anderweitig
    eingereicht oder veröffentlicht wurde.%
  }{%
    I hereby declare that I have written this diploma thesis independently
    and without inadmissible assistance. All sources and aids used are stated
    completely and correctly, and content taken from other works is marked
    accordingly. I confirm that this thesis has not been submitted or
    published elsewhere in this form.%
  }%
}

\newcommand{\eigenstaendigkeitserklaerung}{%
  \vorspannkapitel{\htl@txt{Eigenständigkeitserklärung}{Declaration of Authorship}}%
  \htl@erklaerungstext
  \par\vspace{\baselineskip}
  \hspace*{\fill}\htl@ort, \htl@abgabedatum
  \par\vspace{2\baselineskip}
  \def\htl@do@mitglied##1##2##3{%
    \par\noindent
    % [t] plus the leading space drops the rule below the name's baseline, so
    % there is room to actually sign above the line instead of on top of it.
    \parbox[t]{0.45\linewidth}{\raggedright\htlNameCase{##2} ##3}%
    \hfill
    \parbox[t]{0.45\linewidth}{\centering
      \vspace*{1.6\baselineskip}
      \rule{\linewidth}{0.4pt}\par
      {\footnotesize\htl@txt{Unterschrift}{Signature}}}%
    \par\vspace{3\baselineskip}}%
  \htl@teamliste
}

% =====================================================================
% Front and back matter
% =====================================================================
% Front matter: unnumbered, NOT in the table of contents
\newcommand{\vorspannkapitel}[1]{\chapter*{#1}}
% Back matter: unnumbered, WITH a table of contents entry
\newcommand{\nachspannkapitel}[1]{%
  \chapter*{#1}\phantomsection\addcontentsline{toc}{chapter}{#1}}

% Subheadings in the front matter: black and bold, or underlined -- the front
% matter deliberately does NOT take the blue capitals of the main part.
\newcommand{\vorspannabschnitt}[1]{%
  \par\addvspace{.8\baselineskip}\noindent\textbf{#1}\par\nobreak}
\newcommand{\vorspannunterpunkt}[1]{%
  \par\addvspace{.5\baselineskip}\noindent\underline{#1}\par\nobreak}

\newcommand{\kurzfassung}[1]{\vorspannkapitel{Kurzfassung}#1}
\newcommand{\abstracttext}[1]{\vorspannkapitel{Abstract}#1}
\newcommand{\danksagung}[1]{%
  \vorspannkapitel{\htl@txt{Danksagung}{Acknowledgements}}#1}

% Table of contents; arabic page numbering restarts at 1 afterwards.
\newcommand{\inhaltsverzeichnis}{%
  \tableofcontents
  \clearpage
  \pagenumbering{arabic}\setcounter{page}{1}%
}

\newcommand{\quellenverzeichnis}{%
  \printbibliography[heading=bibintoc,
                     title={\htl@txt{Quellenverzeichnis}{References}}]}
\newcommand{\abbildungsverzeichnis}{\listoffigures}
\newcommand{\tabellenverzeichnis}{\listoftables}
% The entry style is set here, right where the list is read, and inside a
% group so nothing leaks. Everything else was tried first: \DeclareTOCStyleEntry
% (which is what figures and tables use), assigning tocbasic's
% \scr@tso@lstlisting@indent directly, and redefining \l@lstlisting in the
% preamble or in \AtBeginDocument. tocbasic puts the 1.5em indent and the
% single-digit number width back in every one of those cases; only a
% redefinition that nothing runs after survives.
\newcommand{\quellcodeverzeichnis}{%
  \nachspannkapitel{\lstlistlistingname}%
  \begingroup
    % 6.2em fits "Quellcode 1:", measured at 60.9pt in the 11pt text font.
    % Too narrow and the label overprints the caption next to it.
    \renewcommand*{\l@lstlisting}[2]{\@dottedtocline{1}{0pt}{6.2em}{##1}{##2}}%
    \@starttoc{lol}%
  \endgroup}

\newenvironment{abkuerzungsverzeichnis}[1][XXXXXX]%
  {\nachspannkapitel{\htl@txt{Abkürzungsverzeichnis}{List of Abbreviations}}%
   \begin{acronym}[#1]}%
  {\end{acronym}}

% =====================================================================
% Appendix: table of AI-based tools
% =====================================================================
\newcommand*{\htl@kiliste}{}
\newcommand{\kihilfsmittel}[4]{%
  \g@addto@macro\htl@kiliste{#1 & #2 & #3 & #4 \\}}

\newcommand{\listekihilfsmittel}{%
  \ifdefempty{\htl@kiliste}{}{%
    \begingroup
    \small
    \setlength{\tabcolsep}{7pt}%
    \newcolumntype{Y}{>{\raggedright\arraybackslash}X}%
    \begin{xltabular}{\linewidth}{@{}YYYY@{}}
      \toprule
      \bfseries\htl@txt{KI-basiertes Hilfsmittel}{AI-based tool} &
      \bfseries\htl@txt{Einsatzform}{Form of use} &
      \bfseries\htl@txt{Betroffene Teile der Arbeit}{Affected parts} &
      \bfseries\htl@txt{Verwendete Prompts}{Prompts used} \\
      \midrule
      \endhead
      \htl@kiliste
      \bottomrule
    \end{xltabular}
    \endgroup}%
}

\endinput
