$pdf_mode      = 1;          # pdflatex
$bibtex_use    = 2;          # always rebuild the bibliography
$biber         = 'biber %O %S';
$out_dir       = 'build';
$aux_dir       = 'build';
$pdflatex      = 'pdflatex -interaction=nonstopmode -halt-on-error -file-line-error %O %S';
$lualatex      = 'lualatex -interaction=nonstopmode -halt-on-error -file-line-error %O %S';
$clean_ext     = 'bbl run.xml lol synctex.gz nav snm';
@default_files = ('diplomarbeit.tex');
