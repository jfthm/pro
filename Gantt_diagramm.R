# Gantt-Diagramm für 4-jähriges nebenberufliches Dissertationsprojekt SprachFit
# Berücksichtigung der SprachFit-Einführungsetappen in Baden-Württemberg

# Pakete laden
if (!require(plotly)) install.packages("plotly")
if (!require(dplyr)) install.packages("dplyr")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(lubridate)) install.packages("lubridate")
if (!require(scales)) install.packages("scales")
if (!require(viridis)) install.packages("viridis")

library(plotly)
library(dplyr)
library(ggplot2)
library(lubridate)
library(scales)
library(viridis)

# Projektdaten für 4-jähriges nebenberufliches Promotionsprojekt
tasks <- data.frame(
  Task = c(
    "1. ORIENTIERUNGSPHASE",
    "1.1 Literaturrecherche & theoretische Fundierung",
    "1.2 Forschungsdesign entwickeln",
    "1.3 Exposé erstellen",
    "2. VORBEREITUNGSPHASE", 
    "2.1 Ethikantrag & Genehmigungen",
    "2.2 Datenzugang ESU verhandeln",
    "2.3 Methodisches Instrumentarium entwickeln",
    "3. EMPIRISCHE PHASE I (Quantitativ)",
    "3.1 ESU-Datenanalyse (Baseline)",
    "3.2 Sozialräumliche Analysen",
    "3.3 Erste quantitative Befunde",
    "4. EMPIRISCHE PHASE II (Qualitativ)",
    "4.1 Experteninterviews vorbereiten",
    "4.2 Interviews mit Bildungsakteuren",
    "4.3 Fokusgruppen durchführen",
    "4.4 Qualitative Datenauswertung",
    "5. LÄNGSSCHNITTANALYSE",
    "5.1 ESU-Daten nach SprachFit-Start",
    "5.2 Implementierungsanalyse",
    "5.3 Wirkungsanalyse SprachFit",
    "6. INTEGRATION & SYNTHESE",
    "6.1 Mixed-Methods Integration",
    "6.2 Governance-Analyse",
    "6.3 Theoretische Einordnung",
    "7. VERSCHRIFTLICHUNG",
    "7.1 Empirie-Kapitel schreiben",
    "7.2 Diskussion & Schlussfolgerungen",
    "7.3 Überarbeitung & Finalisierung",
    "8. ABSCHLUSSPHASE",
    "8.1 Finale Überarbeitung",
    "8.2 Einreichung & Begutachtung",
    "8.3 Verteidigung & Publikation"
  ),
  Start = as.Date(c(
    # Orientierungsphase (Jan 2025 - Dez 2025)
    "2025-01-01", "2025-01-01", "2025-06-01", "2025-10-01",
    # Vorbereitungsphase (Okt 2025 - Mai 2026)
    "2025-10-01", "2025-10-01", "2025-12-01", "2026-02-01",
    # Empirische Phase I (Apr 2026 - Jan 2027)
    "2026-04-01", "2026-04-01", "2026-07-01", "2026-10-01",
    # Empirische Phase II (Nov 2026 - Aug 2027)
    "2026-11-01", "2026-11-01", "2027-01-01", "2027-04-01", "2027-06-01",
    # Längsschnittanalyse (Aug 2027 - Mai 2028) - nach SprachFit-Start
    "2027-08-01", "2027-08-01", "2027-11-01", "2028-02-01",
    # Integration & Synthese (Apr 2028 - Nov 2028)
    "2028-04-01", "2028-04-01", "2028-07-01", "2028-09-01",
    # Verschriftlichung (Sep 2028 - Aug 2029)
    "2028-09-01", "2028-09-01", "2029-01-01", "2029-05-01",
    # Abschlussphase (Aug 2029 - Dez 2029)
    "2029-08-01", "2029-08-01", "2029-10-01", "2029-11-01"
  )),
  End = as.Date(c(
    # Orientierungsphase
    "2025-12-31", "2025-09-30", "2025-09-30", "2025-12-31",
    # Vorbereitungsphase
    "2026-05-31", "2025-11-30", "2026-01-31", "2026-05-31",
    # Empirische Phase I
    "2027-01-31", "2026-09-30", "2026-12-31", "2027-01-31",
    # Empirische Phase II
    "2027-08-31", "2026-12-31", "2027-06-30", "2027-05-31", "2027-08-31",
    # Längsschnittanalyse
    "2028-05-31", "2027-12-31", "2028-03-31", "2028-05-31",
    # Integration & Synthese
    "2028-11-30", "2028-06-30", "2028-08-31", "2028-11-30",
    # Verschriftlichung
    "2029-08-31", "2028-12-31", "2029-04-30", "2029-08-31",
    # Abschlussphase
    "2029-12-31", "2029-09-30", "2029-10-31", "2029-12-31"
  )),
  Phase = c(
    "Orientierung", "Orientierung", "Orientierung", "Orientierung",
    "Vorbereitung", "Vorbereitung", "Vorbereitung", "Vorbereitung",
    "Empirie-I", "Empirie-I", "Empirie-I", "Empirie-I",
    "Empirie-II", "Empirie-II", "Empirie-II", "Empirie-II", "Empirie-II",
    "Längsschnitt", "Längsschnitt", "Längsschnitt", "Längsschnitt",
    "Integration", "Integration", "Integration", "Integration",
    "Schreibphase", "Schreibphase", "Schreibphase", "Schreibphase",
    "Abschluss", "Abschluss", "Abschluss", "Abschluss"
  ),
  Priority = c(
    "Hoch", "Hoch", "Hoch", "Kritisch",
    "Hoch", "Kritisch", "Kritisch", "Hoch",
    "Hoch", "Hoch", "Hoch", "Hoch",
    "Hoch", "Mittel", "Hoch", "Hoch", "Hoch",
    "Kritisch", "Kritisch", "Hoch", "Kritisch",
    "Hoch", "Hoch", "Hoch", "Hoch",
    "Hoch", "Hoch", "Hoch", "Kritisch",
    "Kritisch", "Kritisch", "Kritisch", "Kritisch"
  ),
  Workload = c(
    100, 60, 40, 80,
    100, 20, 30, 60,
    100, 70, 50, 40,
    100, 30, 80, 60, 90,
    100, 70, 60, 80,
    100, 60, 50, 70,
    100, 80, 60, 90,
    100, 70, 40, 60
  )
)

# SprachFit-Meilensteine in Baden-Württemberg
sprachfit_milestones <- data.frame(
  Milestone = c(
    "SprachFit Qualifizierung startet",
    "ESU-Weiterentwicklung abgeschlossen", 
    "Pilotphase SprachFit beginnt",
    "Schuljahr 2027/28: Teilnahmepflicht",
    "Schuljahr 2028/29: Flächendeckung",
    "Erste Wirkungsdaten verfügbar",
    "Vollständige Implementierung"
  ),
  Date = as.Date(c(
    "2025-03-01", "2025-08-01", "2026-09-01", 
    "2027-08-01", "2028-08-01", "2028-12-01", "2029-06-01"
  )),
  Type = "SprachFit-Meilenstein",
  Description = c(
    "Beginn ZSL-Qualifizierung",
    "Neue ESU-Verfahren implementiert",
    "Erste Kommunen starten",
    "Verpflichtende Teilnahme",
    "Landesweite Umsetzung", 
    "Erste Evaluationsdaten",
    "System etabliert"
  )
)

# Persönliche Dissertations-Meilensteine
dissertation_milestones <- data.frame(
  Milestone = c(
    "Exposé verteidigt",
    "Datenzugang ESU gesichert",
    "Baseline-Analyse abgeschlossen",
    "Qualitative Erhebung beendet",
    "SprachFit-Wirkungsanalyse",
    "Rohfassung fertig",
    "Dissertation eingereicht"
  ),
  Date = as.Date(c(
    "2025-12-31", "2026-01-31", "2027-01-31",
    "2027-08-31", "2028-05-31", "2029-08-31", "2029-10-31"
  )),
  Type = "Dissertation-Meilenstein"
)

# Farben für Phasen definieren
phase_colors <- c(
  "Orientierung" = "#2E86AB",
  "Vorbereitung" = "#A23B72", 
  "Empirie-I" = "#F18F01",
  "Empirie-II" = "#C73E1D",
  "Längsschnitt" = "#592E83",
  "Integration" = "#1B998B",
  "Schreibphase" = "#F4B942",
  "Abschluss" = "#A4243B"
)

# Task-Reihenfolge und Meilenstein-Positionen vorbereiten
tasks$task_order <- nrow(tasks):1
sprachfit_milestones$y_pos <- 35 - (1:nrow(sprachfit_milestones) * 1.2)
dissertation_milestones$y_pos <- 36 - (1:nrow(dissertation_milestones) * 0.8)

# Gantt-Diagramm erstellen
p <- ggplot() +
  # Hauptarbeitspakete
  geom_segment(data = tasks, 
               aes(x = Start, xend = End, 
                   y = reorder(Task, task_order), 
                   yend = reorder(Task, task_order),
                   color = Phase, linewidth = Priority), 
               alpha = 0.8) +
  
  # Start- und Endpunkte
  geom_point(data = tasks, aes(x = Start, y = reorder(Task, task_order), 
                               color = Phase), size = 2.5) +
  geom_point(data = tasks, aes(x = End, y = reorder(Task, task_order), 
                               color = Phase), size = 2.5) +
  
  # SprachFit-Meilensteine
  geom_vline(data = sprachfit_milestones, 
             aes(xintercept = Date), 
             color = "red", linetype = "dashed", alpha = 0.7, linewidth = 1) +
  
  geom_text(data = sprachfit_milestones,
            aes(x = Date, y = y_pos, label = Milestone),
            angle = 90, hjust = 0, vjust = 0.5, size = 2.8, color = "red", fontface = "bold") +
  
  # Dissertations-Meilensteine
  geom_point(data = dissertation_milestones, 
             aes(x = Date, y = y_pos),
             shape = 18, size = 4, color = "darkgreen") +
  
  geom_text(data = dissertation_milestones,
            aes(x = Date, y = y_pos, label = Milestone),
            hjust = -0.1, vjust = 0.5, size = 2.5, color = "darkgreen", fontface = "bold") +
  
  # Styling
  scale_color_manual(values = phase_colors) +
  scale_linewidth_manual(values = c("Niedrig" = 2, "Mittel" = 4, "Hoch" = 6, "Kritisch" = 8)) +
  scale_x_date(date_breaks = "6 months", 
               date_labels = "%b %Y",
               expand = expansion(mult = c(0.02, 0.25))) +
  
  labs(
    title = "Dissertationsprojekt SprachFit (2025-2029): 4-jähriges nebenberufliches Promotionsvorhaben",
    subtitle = "Einschulungsuntersuchung im Rahmen des Landesprogramms SprachFit aus Sicht regionaler Bildungsakteure",
    x = "Zeitraum (2025-2029)",
    y = "Arbeitspakete und Projektphasen",
    color = "Projektphase",
    linewidth = "Priorität",
    caption = paste("Rote Linien: SprachFit-Einführungsetappen BW | Grüne Rauten: Dissertations-Meilensteine\n",
                    "Nebenberuflich durchgeführt | Flächendeckende SprachFit-Einführung: Schuljahr 2028/29\n",
                    "Erstellt für Baden-Württemberg Bildungsforschung")
  ) +
  
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold", hjust = 0),
    plot.subtitle = element_text(size = 11, hjust = 0, color = "gray20"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    axis.text.y = element_text(size = 8),
    axis.title = element_text(size = 10, face = "bold"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 9),
    legend.text = element_text(size = 8),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray90", linetype = "dotted"),
    panel.grid.major.y = element_blank(),
    plot.caption = element_text(size = 8, color = "gray50", hjust = 0, lineheight = 1.2),
    legend.box = "horizontal",
    strip.text = element_text(face = "bold")
  ) +
  guides(
    color = guide_legend(override.aes = list(linewidth = 3), ncol = 4),
    linewidth = guide_legend(ncol = 4)
  )

# Diagramm anzeigen
print(p)

# Detailanalyse für nebenberufliche Promotion
cat("\n", paste(rep("=", 60), collapse=""), "\n")
cat("4-JÄHRIGES NEBENBERUFLICHES DISSERTATIONSPROJEKT\n")
cat(paste(rep("=", 60), collapse=""), "\n")
cat("Projektstart:", format(min(tasks$Start), "%d.%m.%Y"), "\n")
cat("Projektende:", format(max(tasks$End), "%d.%m.%Y"), "\n")
cat("Gesamtdauer:", round(as.numeric(max(tasks$End) - min(tasks$Start))/365.25, 1), "Jahre\n")
cat("Arbeitspakete:", nrow(tasks), "\n\n")

# SprachFit-Synchronisation
cat("SYNCHRONISATION MIT SPRACHFIT-EINFÜHRUNG:\n")
cat(paste(rep("-", 45), collapse=""), "\n")
for(i in 1:nrow(sprachfit_milestones)) {
  cat(format(sprachfit_milestones$Date[i], "%d.%m.%Y"), ":", 
      sprachfit_milestones$Milestone[i], "\n")
}

# Phasenverteilung
phase_summary <- tasks %>%
  filter(!grepl("^[0-9]\\.", Task)) %>%  # Nur Hauptphasen
  group_by(Phase) %>%
  summarise(
    Anzahl_Tasks = n(),
    Dauer_Monate = round(sum(as.numeric(End - Start))/30.44, 1),
    Workload_Gesamt = sum(Workload, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  arrange(desc(Workload_Gesamt))

cat("\n\nPHASENVERTEILUNG:\n")
cat(paste(rep("-", 25), collapse=""), "\n")
print(phase_summary)

# Kritische Erfolgsfaktoren für nebenberufliche Promotion
cat("\n\nKRITISCHE ERFOLGSFAKTOREN (nebenberuflich):\n")
cat(paste(rep("-", 48), collapse=""), "\n")
cat("1. ZEITMANAGEMENT:\n")
cat("   - Wöchentlich 15-20h für Dissertation einplanen\n")
cat("   - Pufferzeiten: +25% pro Phase wegen Berufstätigkeit\n")
cat("   - Schreibzeiten: Frühe Morgenstunden oder Wochenenden\n\n")

cat("2. DATENZUGANG:\n")
cat("   - ESU-Daten: Verhandlungen mit Gesundheitsämtern 2025/26\n")
cat("   - SprachFit-Daten: Abhängig von Implementierungsfortschritt\n")
cat("   - Backup-Strategien für verzögerte Datenverfügbarkeit\n\n")

cat("3. SPRACHFIT-ABHÄNGIGKEITEN:\n")
cat("   - 2027/28: Erste belastbare Implementierungsdaten\n")
cat("   - 2028/29: Vollständige Wirkungsanalyse möglich\n")
cat("   - Längsschnittdesign optimal für Promotionszeitraum\n\n")

# Risikomanagement
cat("RISIKOMANAGEMENT:\n")
cat(paste(rep("-", 18), collapse=""), "\n")
cat("HOCH: Datenzugang ESU (Abhängigkeit von Kooperation)\n")
cat("HOCH: SprachFit-Implementierungsverzögerungen\n")
cat("MITTEL: Work-Life-Balance bei nebenberuflicher Durchführung\n")
cat("MITTEL: Experteninterviews (Verfügbarkeit Bildungsakteure)\n")
cat("NIEDRIG: Methodische Herausforderungen\n\n")

# Nebenberufliche Besonderheiten
cat("NEBENBERUFLICHE ANPASSUNGEN:\n")
cat(paste(rep("-", 29), collapse=""), "\n")
cat("- Längere Laufzeit kompensiert reduzierte Wochenarbeitszeit\n")
cat("- Parallele Phasen minimiert für bessere Vereinbarkeit\n")
cat("- Intensive Schreibphasen in beruflichen Ruhephasen\n")
cat("- Konferenzteilnahmen auf Kernveranstaltungen fokussiert\n")
cat("- Datenerhebung in schulfreien Zeiten geplant\n\n")

# Optimaler Zeitraum für Promotion
cat("WARUM 2025-2029 OPTIMAL:\n")
cat(paste(rep("-", 24), collapse=""), "\n")
cat("??? SprachFit-Implementierung begleitbar von Anfang an\n")
cat("??? ESU-Weiterentwicklung 2025 als natürlicher Startpunkt\n")
cat("??? Längsschnittdaten SprachFit ab 2027/28 verfügbar\n")
cat("??? Vollständige Wirkungsanalyse bis 2029 möglich\n")
cat("??? Policy-Relevanz durch zeitnahe Implementierungsforschung\n")

# Interaktives Diagramm
p_interactive <- ggplotly(p, tooltip = c("text")) %>%
  layout(
    title = list(
      text = "Dissertationsprojekt SprachFit 2025-2029<br><sub>Nebenberufliche 4-Jahres-Promotion</sub>",
      font = list(size = 14)
    ),
    margin = list(l = 50, r = 150, t = 120, b = 100),
    legend = list(orientation = "h", x = 0, y = -0.2)
  )

print(p_interactive)
