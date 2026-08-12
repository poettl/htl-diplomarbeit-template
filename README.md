# Diploma Thesis Template — HTL Donaustadt, Department of Information Technology

LaTeX template for your diploma thesis. Title page, declaration of authorship,
headers and footers, every list, and the AI tools table in the appendix are
done — all you write is the content.

The thesis itself is written in German, so the template's own text and the
command names stay German. Only this documentation is in English.

---

## 1. Getting started in 5 minutes

### Fork the repository and work with Git

**1. Fork once per team.** A fork is a copy of a repository that you can work
on without touching the original. One person clicks **Fork** at the top right
of the repository page — that copy becomes the team repository. Either use a
GitHub organisation or create it under one team member's account.

**2. Add everyone.** Under **Settings → Collaborators**, add the other team
members and your supervisors.

**3. Clone the repository.** Use [Fork](https://git-fork.com/) or the command
line:

```bash
git clone https://github.com/USERNAME/htl-diplomarbeit-template.git
cd htl-diplomarbeit-template
```

**4. Install a TeX distribution:**

| System | Installation |
| --- | --- |
| macOS | [MacTeX](https://tug.org/mactex/) |
| Windows | [MiKTeX](https://miktex.org/) or [TeX Live](https://tug.org/texlive/) |
| Linux | `sudo apt install texlive-full latexmk biber` |

Then, in the project folder:

```bash
make pdf      # builds build/diplomarbeit.pdf
make watch    # rebuilds automatically on every change
make clean    # deletes the auxiliary files
```

It works just as well without `make`:

```bash
latexmk -pdf diplomarbeit.tex
```

> Good editors: VS Code with the *LaTeX Workshop* extension, TeXstudio, or
> Texifier.

### What about Overleaf?

We advise against it. The free tier is heavily limited and not suitable for a
diploma thesis.

---

## 2. First step: `metadata.tex`

This is the **only** file you have to touch at the start. It holds the title,
the team, the supervisors, the class, and the school year. Everything else is
derived from it.

```latex
\titel{Automatisiertes Bewässerungssystem für den Schulgarten}
\kurztitel{Bewässerungssystem}           % appears left in every page header

\teammitglied{MUSTERFRAU}{Maria}         % once per person
\teammitglied{BEISPIEL}{Ben}
\teammitglied{VORLAGE}{Vera}

\betreuung[Betreuerin]{Titel Vorname NACHNAME, Titel}
\betreuung[Betreuer]{Titel Vorname NACHNAME, Titel}

\schuljahr{2026/27}
\abteilung{Informationstechnologie}
\klasse{5AHITN}
\ort{Wien}
```

The date under the declaration of authorship is the build date unless you set
`\abgabedatum{...}` — which is usually what you want, because the printout you
sign carries the day you printed it.

`\teammitglied` automatically produces:

- the `MUSTERFRAU Maria` lines on the title page,
- one signature block per person in the declaration of authorship,
- the short form `M. Musterfrau` for the page header.

If a **given name** starts with a special character (Ö, Č, Š …), supply the
short form yourself: `\teammitglied[Ö. Beispiel]{BEISPIEL}{Öznur}`.

No project logo? Just delete the `\projektlogo{...}` line in `metadata.tex`.

---

## 3. Where does what go?

```
metadata.tex               title, team, supervisors    <- start here
frontmatter/
  problem-statement.tex    content of the approved topic proposal
  abstract.tex             Kurzfassung, Abstract, acknowledgements
chapters/
  01-introduction.tex      motivation, objectives
  02-project-planning.tex  process model, sprints
  03-fundamentals.tex      the technologies you use
  04-implementation.tex    what you built              <- the core chapter
  05-evaluation.tex        target/actual comparison, conclusion
appendix/
  ai-tools.tex             AI tools used
images/                    all screenshots and diagrams
references.bib             all sources
diplomarbeit.tex           order of the parts + list of abbreviations
htldon.cls                 the layout — do not modify
build/                     created by the build, not tracked in Git
```

Need an extra chapter? Create a new file in `chapters/` and pull it in at the
right place in `diplomarbeit.tex` with `\input{chapters/06-...}`.

---

## 4. The five things you need constantly

### Include an image

The caption belongs **below** the image:

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.75\linewidth]{images/startseite.png}
  \caption{Übersicht der Startseite}
  \label{abb:startseite}
\end{figure}
```

Refer to it in the text: `wie in Abb.~\ref{abb:startseite} zu sehen`. Never
write "see image above" — the position can shift when the page breaks.

Figures and tables are numbered continuously across the whole thesis
(Abb. 1, Abb. 2, Abb. 3 …), not per chapter, and are labelled `Abb.` and
`Tab.` as the department template requires.

### Cite a source

Add an entry to `references.bib`, then in the text:

```latex
Magic Links gelten als sichere Alternative zu Passwörtern~\cite{matiushin2021}.
```

That renders as `[7]`. Several sources: `\cite{quelle1,quelle2}`.

**Keep `references.bib` up to date automatically.** Maintaining it by hand
works, but it drifts. The setup that holds up over a school year is
[Zotero](https://www.zotero.org/) plus the
[Better BibTeX](https://retorque.re/zotero-better-bibtex/) plugin:

1. Collect sources in Zotero — the browser connector grabs a paper, a
   standard, or a web page including its access date in one click.
2. Put everything for the thesis into one Zotero collection.
3. Right-click the collection → **Export Collection** → format **Better
   BibTeX**, tick **Keep updated**, and save it over `references.bib`.

From then on Zotero rewrites `references.bib` whenever you add or change a
source — you only write the `\cite`. Two things worth doing right away:

- **Pin the citation keys.** Better BibTeX generates keys like
  `matiushin2021`, but regenerates them when metadata changes, which silently
  breaks every `\cite` that used the old one. Right-click an entry →
  *Better BibTeX → Pin BibTeX key* freezes it.
- **Commit `references.bib`.** It is a normal source file. The Zotero library
  itself lives only on one machine, so the `.bib` is what the team and the
  build share.

Not attached to Zotero? [JabRef](https://www.jabref.org/) edits `.bib` files
directly and needs no export step. Single entries also come straight out of
Google Scholar (*Cite → BibTeX*) or IEEE Xplore — fine for a handful of
sources, tedious past that.

### Show code

Short excerpts as a listing — **never as a screenshot**:

```latex
\begin{lstlisting}[language=Python, caption={Berechnung des Gesamtpreises}, label=code:preis]
def berechne_gesamtpreis(positionen):
    return sum(p.menge * p.einzelpreis for p in positionen)
\end{lstlisting}
```

Single identifiers inside a paragraph: `\texttt{berechne\_gesamtpreis}`.

### Use an abbreviation

Define it in the list of abbreviations in `diplomarbeit.tex`:

```latex
\acro{API}{Application Programming Interface}
```

In the text, always write `\ac{API}`. The first occurrence is spelled out
automatically, every later one uses the short form.

### Who appears in the header?

Every page shows its author at the top right:

```latex
\chapter{Praktische Realisierung}
\abschnittsautor{B. Beispiel}        % ALWAYS directly after \chapter
```

For parts written together: `\abschnittsautor{\alleautoren}`.

**Authorship is per section, not just per chapter.** Split a chapter between
team members by declaring the author again after each `\section`:

```latex
\section{Umsetzung Teilbereich A}
\abschnittsautor{B. Beispiel}
...
\section{Umsetzung Teilbereich B}
\abschnittsautor{V. Vorlage}
```

If both sections land on the same page, the header names both:
`B. Beispiel, V. Vorlage`. On pages with no change at all, the last declared
author carries over, so you only write it where something actually changes.

> **Careful:** `\abschnittsautor` has to come *after* `\chapter` or
> `\section`. Before it, the change still lands on the previous page.

> **One case stays manual.** If a section runs past a page break and the next
> author's section starts further down that same page, only the second one is
> listed — LaTeX cannot tell how much of the page belonged to whom. Name both
> by hand there: `\abschnittsautor{B. Beispiel, V. Vorlage}`. Word has the
> same limitation, which is why the department guideline asks you to name
> everyone who worked on a page.

---

## 5. Reference

### Class options

```latex
\documentclass[deutsch,ieee,lato]{htldon}
```

| Option | Meaning |
| --- | --- |
| `deutsch` *(default)* / `englisch` | language of all fixed text |
| `ieee` *(default)* / `harvard` | citation style `[1]` or `(Author, 2024)` |
| `lato` *(default)* / `inter` / `carlito` | typeface |
| `aptos` | the real Aptos font, needs LuaLaTeX **and** Aptos installed |
| `entwurf` | ENTWURF (draft) watermark on every page |

> The department guideline mandates IEEE. Only use `harvard` if your
> supervisor asks for it.

### Template commands

| Command | Effect |
| --- | --- |
| `\titelblatt` | title page |
| `\eigenstaendigkeitserklaerung` | declaration with one signature line per team member |
| `\inhaltsverzeichnis` | table of contents; page numbering restarts at 1 here |
| `\vorspannkapitel{...}` | unnumbered heading, **not** in the table of contents |
| `\nachspannkapitel{...}` | unnumbered heading **with** a table of contents entry |
| `\vorspannabschnitt{...}` | bold subheading in the front matter |
| `\vorspannunterpunkt{...}` | underlined subheading in the front matter |
| `\quellenverzeichnis` | bibliography |
| `\abbildungsverzeichnis` | list of figures |
| `\tabellenverzeichnis` | list of tables |
| `\quellcodeverzeichnis` | list of source code listings |
| `abkuerzungsverzeichnis` environment | list of abbreviations |
| `\kihilfsmittel{}{}{}{}` | one row in the AI tools table |
| `\listekihilfsmittel` | typesets the AI tools table |
| `\alleautoren` | all team members in short form |

---

## 6. When something goes wrong

| Message / problem | Cause and fix |
| --- | --- |
| `Undefined control sequence` | Typo in a command, or a missing `{}`. The line number in the error is almost always right. |
| `File 'images/xy.png' not found` | Wrong file name or path. Case matters (on Linux and Overleaf, not on Windows — so be extra careful there). |
| A citation renders as `[?]` | Check `references.bib`, then run `make clean` and rebuild. The key in `\cite` has to match the BibTeX entry exactly. |
| A reference renders as `??` | Build twice — `latexmk` normally handles this itself. |
| `Overfull \hbox` | Just a warning: a line sticks into the margin. Usually a long word or a URL. Ignorable unless you can actually see it. |
| Image in the wrong place | Normal. LaTeX moves figures to where they fit, which is why you always refer to them with `\ref`. |
| Everything broken after a change | `make clean`, then rebuild. |

After that, `build/diplomarbeit.log` is the next place to look — the first
error from the top is the relevant one, everything after it is fallout.

---

## 7. Working as a team

- **One repository for everyone**, each person works on their own chapter
  files. That way there are hardly any merge conflicts.
- `build/` is in `.gitignore` — **never** commit the PDF or the auxiliary
  files.
- Write **one sentence per line** in the `.tex` files. Then `git diff` shows
  exactly what changed instead of a whole paragraph.
- Always pull the current state before you start working: `git pull`.

### The PDF builds itself: GitHub Actions

Your fork contains `.github/workflows/build.yml`. That is a **GitHub Action** —
a build job GitHub runs automatically on its own server on every push. It does
exactly what `make pdf` does locally, only in the cloud.

What you get from it:

- **You notice immediately when the thesis stops compiling.** If somebody
  forgets a brace and pushes, the run turns red and everyone sees it — instead
  of it surfacing two weeks later during a merge.
- **Everyone can get the current PDF** without having LaTeX installed. Handy
  for your supervisors: click the run, download the PDF, done.
- **It is the neutral authority.** "But it builds on my machine" no longer
  counts — what counts is what the server says.

How to look at it:

1. Open the **Actions** tab in your fork.
2. Click the topmost run (green check = fine, red X = error).
3. At the bottom under **Artifacts** you'll find `diplomarbeit` — that's the
   PDF.
4. On a red X: click the *LaTeX-Dokument übersetzen* step. The error is the
   same one you would get locally.

Artifacts are deleted automatically after a few weeks. This is not a backup —
your backup is the repository itself.

> If GitHub reports that an action is outdated, raise the version numbers after
> the `@` in `build.yml` (`actions/checkout@v7` and so on).

---

## 8. Checklist before submission

- [ ] `metadata.tex` complete, names and title spelled correctly
- [ ] Declaration of authorship signed by everyone (on the printout)
- [ ] Both the German Kurzfassung **and** the English Abstract present
- [ ] Every chapter has the right `\abschnittsautor`
- [ ] Every figure and table has a caption and is referenced in the text
- [ ] No entry in the bibliography that is never cited
- [ ] AI tools fully documented in `appendix/ai-tools.tex`
- [ ] Build produces no errors and no `??` / `[?]` in the PDF

---

## Open questions for the department

1. **Wording of the declaration of authorship** — if there is an officially
   prescribed text, it belongs in `htldon.cls` (macro `\htl@erklaerungstext`).
2. **Page numbers** — the template centres a page number in the footer. To
   remove it, replace `\cfoot{\pagemark}` with `\cfoot{}` in `htldon.cls`.
3. **Logo** — `images/logo-htl-donaustadt.png` is a raster image. If a vector
   version exists, please replace it.

---

## License

`htldon.cls` and the example files are MIT licensed. The school logo is
excluded — see `LICENSE` for details.
