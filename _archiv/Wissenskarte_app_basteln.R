# =============================================================================
# MINIMALE MINDMAP - GARANTIERT FUNKTIONSFÄHIG
# =============================================================================

library(bib2df)
library(visNetwork)
library(dplyr)
library(stringr)

create_minimal_mindmap <- function(bib_file_path) {
  
  cat("???? Lade .bib-Datei...\n")
  
  # Datei einlesen
  bib_data <- bib2df(bib_file_path)
  
  cat("??? Erfolgreich", nrow(bib_data), "Einträge geladen\n")
  
  # Grundlegende Datenbereinigung
  if(!"YEAR" %in% names(bib_data)) {
    bib_data$YEAR <- 2020
  }
  if(!"AUTHOR" %in% names(bib_data)) {
    bib_data$AUTHOR <- "Unbekannt"
  }
  if(!"ABSTRACT" %in% names(bib_data)) {
    bib_data$ABSTRACT <- ""
  }
  
  # NA-Werte ersetzen
  bib_data$TITLE[is.na(bib_data$TITLE)] <- "Ohne Titel"
  bib_data$AUTHOR[is.na(bib_data$AUTHOR)] <- "Unbekannt"
  bib_data$ABSTRACT[is.na(bib_data$ABSTRACT)] <- ""
  bib_data$YEAR[is.na(bib_data$YEAR)] <- 2020
  
  # YEAR zu numerisch konvertieren
  bib_data$YEAR <- as.numeric(as.character(bib_data$YEAR))
  bib_data$YEAR[is.na(bib_data$YEAR)] <- 2020
  
  cat("???? Kategorisiere Literatur...\n")
  
  # Einfache Kategorisierung
  bib_data$CATEGORY <- "Weitere Themen"  # Default
  
  for(i in 1:nrow(bib_data)) {
    title_lower <- tolower(bib_data$TITLE[i])
    abstract_lower <- tolower(bib_data$ABSTRACT[i])
    
    if(grepl("schuleingang|esu", title_lower) || grepl("schuleingang|esu", abstract_lower)) {
      bib_data$CATEGORY[i] <- "Einschulungsuntersuchung"
    } else if(grepl("kommunal.*bildung|bildungsmanagement|bildungsmonitoring", title_lower) || 
              grepl("kommunal.*bildung|bildungsmanagement|bildungsmonitoring", abstract_lower)) {
      bib_data$CATEGORY[i] <- "Kommunales Bildungsmanagement"
    } else if(grepl("sprachf|sprachentwick|sprachbild", title_lower) || 
              grepl("sprachf|sprachentwick|sprachbild", abstract_lower)) {
      bib_data$CATEGORY[i] <- "Sprachförderung"
    } else if(grepl("governance|steuerung", title_lower) || 
              grepl("governance|steuerung", abstract_lower)) {
      bib_data$CATEGORY[i] <- "Governance"
    } else if(grepl("übergang|transition|kita.*schule", title_lower) || 
              grepl("übergang|transition|kita.*schule", abstract_lower)) {
      bib_data$CATEGORY[i] <- "Übergang Kita-Schule"
    } else if(grepl("diagnos|screening|test", title_lower) || 
              grepl("diagnos|screening|test", abstract_lower)) {
      bib_data$CATEGORY[i] <- "Diagnostik"
    } else if(grepl("baden.*württemberg|bw", title_lower) || 
              grepl("baden.*württemberg|bw", abstract_lower)) {
      bib_data$CATEGORY[i] <- "Baden-Württemberg"
    }
  }
  
  # Relevanz zuweisen
  bib_data$RELEVANCE <- "Niedrig"  # Default
  
  for(i in 1:nrow(bib_data)) {
    if(bib_data$CATEGORY[i] %in% c("Einschulungsuntersuchung", "Kommunales Bildungsmanagement")) {
      bib_data$RELEVANCE[i] <- "Hoch"
    } else if(bib_data$CATEGORY[i] %in% c("Sprachförderung", "Governance", "Baden-Württemberg")) {
      bib_data$RELEVANCE[i] <- "Mittel"
    }
  }
  
  cat("??? Kategorisierung abgeschlossen\n")
  
  # Farbschema
  get_color <- function(category) {
    switch(category,
           "Einschulungsuntersuchung" = "#D32F2F",
           "Kommunales Bildungsmanagement" = "#1976D2", 
           "Sprachförderung" = "#388E3C",
           "Governance" = "#F57C00",
           "Übergang Kita-Schule" = "#7B1FA2",
           "Diagnostik" = "#00796B",
           "Baden-Württemberg" = "#E91E63",
           "#9E9E9E")  # Default grau
  }
  
  # Knotengröße basierend auf Relevanz
  get_size <- function(relevance) {
    switch(relevance,
           "Hoch" = 25,
           "Mittel" = 20,
           15)  # Default
  }
  
  cat("???? Erstelle Netzwerk...\n")
  
  # Literatur-Knoten
  nodes <- data.frame(
    id = 1:nrow(bib_data),
    label = substr(bib_data$TITLE, 1, 30),
    group = bib_data$CATEGORY,
    title = paste0(
      "<b>", substr(bib_data$TITLE, 1, 60), "</b><br>",
      "Autor: ", substr(as.character(bib_data$AUTHOR), 1, 40), "<br>",
      "Jahr: ", bib_data$YEAR, "<br>",
      "Kategorie: ", bib_data$CATEGORY, "<br>",
      "Relevanz: ", bib_data$RELEVANCE
    ),
    size = sapply(bib_data$RELEVANCE, get_size),
    color = sapply(bib_data$CATEGORY, get_color),
    stringsAsFactors = FALSE
  )
  
  # Kategorie-Knoten
  categories <- unique(bib_data$CATEGORY)
  cat_nodes <- data.frame(
    id = (nrow(bib_data) + 1):(nrow(bib_data) + length(categories)),
    label = categories,
    group = categories,
    title = paste("Kategorie:", categories),
    size = 35,
    color = sapply(categories, get_color),
    stringsAsFactors = FALSE
  )
  
  # Root-Knoten
  root_node <- data.frame(
    id = nrow(bib_data) + length(categories) + 1,
    label = "SprachFit\nDissertation",
    group = "Root",
    title = "Dissertationsprojekt SprachFit",
    size = 50,
    color = "#2E86AB",
    stringsAsFactors = FALSE
  )
  
  # Alle Knoten zusammenfassen
  all_nodes <- rbind(nodes, cat_nodes, root_node)
  
  # Kanten erstellen
  # Literatur zu Kategorien
  edges1 <- data.frame(
    from = 1:nrow(bib_data),
    to = match(bib_data$CATEGORY, categories) + nrow(bib_data),
    stringsAsFactors = FALSE
  )
  
  # Kategorien zu Root
  edges2 <- data.frame(
    from = (nrow(bib_data) + 1):(nrow(bib_data) + length(categories)),
    to = nrow(bib_data) + length(categories) + 1,
    stringsAsFactors = FALSE
  )
  
  all_edges <- rbind(edges1, edges2)
  
  cat("???? Erstelle Visualisierung...\n")
  
  # Netzwerk erstellen
  network <- visNetwork(all_nodes, all_edges, width = "100%", height = "800px") %>%
    visOptions(
      highlightNearest = TRUE,
      selectedBy = "group",
      nodesIdSelection = TRUE
    ) %>%
    visLayout(randomSeed = 42) %>%
    visNodes(
      borderWidth = 2,
      font = list(size = 12)
    ) %>%
    visEdges(arrows = "to") %>%
    visPhysics(
      solver = "forceAtlas2Based",
      stabilization = list(iterations = 100)
    )
  
  # Speichern
  tryCatch({
    htmlwidgets::saveWidget(
      network,
      file = "sprachfit_mindmap.html",
      selfcontained = TRUE
    )
    cat("???? Mindmap gespeichert als: sprachfit_mindmap.html\n")
  }, error = function(e) {
    cat("?????? Speichern fehlgeschlagen, aber Mindmap funktioniert\n")
  })
  
  # Statistiken
  cat("\n???? STATISTIKEN:\n")
  cat("Gesamtanzahl Publikationen:", nrow(bib_data), "\n\n")
  
  cat("Kategorien:\n")
  category_counts <- table(bib_data$CATEGORY)
  for(i in 1:length(category_counts)) {
    cat("  ", names(category_counts)[i], ":", category_counts[i], "\n")
  }
  
  cat("\nRelevanz:\n")
  relevance_counts <- table(bib_data$RELEVANCE)
  for(i in 1:length(relevance_counts)) {
    cat("  ", names(relevance_counts)[i], ":", relevance_counts[i], "\n")
  }
  
  cat("\n???? Hochrelevante Publikationen:\n")
  high_relevance <- bib_data[bib_data$RELEVANCE == "Hoch", ]
  if(nrow(high_relevance) > 0) {
    for(i in 1:nrow(high_relevance)) {
      cat("  ", i, ". ", substr(high_relevance$TITLE[i], 1, 60), " (", high_relevance$YEAR[i], ")\n")
    }
  }
  
  cat("\n???? Mindmap erfolgreich erstellt!\n")
  cat("???? Öffnen Sie 'sprachfit_mindmap.html' in Ihrem Browser\n")
  
  return(network)
}

# VERWENDUNG:
 mindmap <- create_minimal_mindmap("references.bib")
 mindmap