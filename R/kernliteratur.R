# Erzeugt kernliteratur.bib aus dem Zotero-Auto-Export: nur Einträge mit dem Tag R_Kernliteratur.
# Bewusst manuell ausführen, damit die Liste auf der Website fest bleibt:
#   Rscript R/kernliteratur.R

quelle <- "../../01_Wissen/05_Bibliographie/promotion.bib"
ziel <- "kernliteratur.bib"

text <- paste(readLines(quelle, encoding = "UTF-8"), collapse = "\n")
eintraege <- strsplit(text, "\n(?=@)", perl = TRUE)[[1]]
kern <- eintraege[grepl("keywords\\s*=\\s*[{][^\n]*R\\\\?_Kernliteratur", eintraege)]

writeLines(enc2utf8(kern), ziel, useBytes = TRUE)
message(length(kern), " Einträge nach ", ziel, " geschrieben.")
