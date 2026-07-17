# 1. chargement des packages
library(ggplot2)
library(dplyr)
library(tidyr)

# 2. importation de la table d'assignation
data_brute <- read.table("results_table_assignation.csv", header = TRUE, sep = ";",quote = "", stringsAsFactors = FALSE)

# 3. renommer et nettoyer les colonnes
colnames(data_brute) <- c("Taxonomie", "sed6_merge", "sed6_unmerge", "sed8_merge", "sed8_unmerge", "sed6total", "sed8total")

data_clean <- data_brute %>%
  mutate(
    # On extrait directement ce qui se trouve après d__, p__ et g__ peu importe leur position
    Domain = ifelse(grepl("d__", Taxonomie), sub(".*d__([^|]+).*", "\\1", Taxonomie), NA),
    Phylum = ifelse(grepl("p__", Taxonomie), sub(".*p__([^|]+).*", "\\1", Taxonomie), NA),
    Genre  = ifelse(grepl("g__", Taxonomie), sub(".*g__([^|]+).*", "\\1", Taxonomie), NA)
  )

# 4. création des 4 grands groupes 
data_categories <- data_clean %>%
  mutate(Categorie = case_when(
    grepl("Bacteria|Pseudomonadati|Bacillati", Taxonomie) ~ "Bactéries",
    grepl("Fungi|Ascomycota|Basidiomycota|Chytridiomycota|Mucoromycota", Taxonomie) ~ "Champignons",
    grepl("Bacillariophyta|Chlorophyta|Rhodophyta|Streptophyta|Viridiplantae", Taxonomie) ~ "Microalgues",
    TRUE ~ "Protistes" # Tout le reste 
  ))

# 5. sélection des colonnes d'intérêt
data_long <- data_categories %>%
  select(Categorie, Phylum, Genre, 
         sed6 = sed6total,  
         sed8 = sed8total) %>% # <-- Corrigé ici !
  pivot_longer(cols = c(sed6, sed8), names_to = "Site", values_to = "Reads") %>%
  filter(!is.na(Reads) & Reads > 0)



# ==============================================================================
# GENERATION DES GRAPHIQUES 
# ==============================================================================

#  GRAPHIQUE 1: 4 catégories principales
data_graph1_empile <- data_long %>%
  group_by(Site, Categorie) %>%
  summarise(Reads = sum(Reads), .groups = 'drop') %>%
  group_by(Site) %>%
  mutate(Abondance_Relative = (Reads / sum(Reads)) * 100)

plot1_final <- ggplot(data_graph1_empile, aes(x = Site, y = Abondance_Relative, fill = Categorie)) +
  geom_bar(stat = "identity", position = "stack", width = 0.5, color = "black") +
  geom_text(aes(label = ifelse(Abondance_Relative > 1.0, sprintf("%.1f%%", Abondance_Relative), "")), 
            position = position_stack(vjust = 0.5), size = 4, fontface = "bold", color = "white") +
  scale_fill_brewer(palette = "Set2") + 
  labs(
    title = "Structure globale du microbiome sédimentaire (Multi-kingdom)",
    x = "Sites de prélèvement",
    y = "Abondance relative globale (%)",
    fill = "Groupes microbiens"
  ) +
  theme_bw() +
  theme(
    axis.text = element_text(size = 11, face = "bold"),
    axis.title = element_text(face = "bold"),
    legend.title = element_text(face = "bold"),
    title = element_text(face = "bold")
  )

print(plot1_final)


#  GRAPHIQUE 2 : zoom au niveau des phylums (top 15) 
top_phylums_par_groupe <- data_long %>%
  filter(!is.na(Phylum) & Phylum != "") %>%
  group_by(Categorie, Phylum) %>%
  summarise(Total_Reads = sum(Reads), .groups = 'drop') %>%
  group_by(Categorie) %>%
  top_n(15, Total_Reads) %>%
  ungroup()

data_graph2 <- data_long %>%
  filter(!is.na(Phylum) & Phylum != "") %>%
  mutate(Phylum_Clean = ifelse(Phylum %in% top_phylums_par_groupe$Phylum, Phylum, "Others")) %>%
  group_by(Site, Categorie, Phylum_Clean) %>%
  summarise(Reads = sum(Reads), .groups = 'drop') %>%
  group_by(Site, Categorie) %>%
  mutate(Abondance_Relative = (Reads / sum(Reads)) * 100)


plot2 <- ggplot(data_graph2, aes(x = Site, y = Abondance_Relative, fill = Phylum_Clean)) +
  geom_bar(stat = "identity", position = "stack", width = 0.6, color = "black") +
  facet_wrap(~Categorie, scales = "free", ncol = 2) +
  labs(
    title = "Profil taxonomique des Phylums (Top 15 par groupe du vivant)",
    x = "Sites de prélèvement",
    y = "Abondance relative au sein du groupe (%)",
    fill = "Phylum"
  ) +
  theme_bw() +
  theme(
    strip.text = element_text(face = "bold", size = 12),
    legend.text = element_text(size = 8),
    axis.text = element_text(face = "bold")
  )

print(plot2)


# GRAPHIQUE 3 : zoom sur le top 15 des genres du phylum majoritaire
phylums_majeurs <- data_long %>%
  filter(!is.na(Phylum) & Phylum != "") %>%
  group_by(Categorie, Phylum) %>%
  summarise(Total_Reads = sum(Reads), .groups = 'drop') %>%
  group_by(Categorie) %>%
  top_n(1, Total_Reads) %>%
  ungroup()

data_filtrée_phylum <- data_long %>%
  filter(Phylum %in% phylums_majeurs$Phylum & !is.na(Genre) & Genre != "")

top_genres_phylum <- data_filtrée_phylum %>%
  group_by(Categorie, Genre) %>%
  summarise(Total_Reads = sum(Reads), .groups = 'drop') %>%
  group_by(Categorie) %>%
  top_n(15, Total_Reads) %>%
  ungroup()

data_graph3_empile <- data_filtrée_phylum %>%
  mutate(Genre_Clean = ifelse(Genre %in% top_genres_phylum$Genre, Genre, "Others")) %>%
  group_by(Site, Categorie, Genre_Clean) %>%
  summarise(Reads = sum(Reads), .groups = 'drop') %>%
  group_by(Site, Categorie) %>%
  mutate(Abondance_Relative = (Reads / sum(Reads)) * 100) %>%
  ungroup()

plot3 <- ggplot(data_graph3_empile, aes(x = Site, y = Abondance_Relative, fill = Genre_Clean)) +
  geom_bar(stat = "identity", position = "stack", width = 0.5, color = "black") +
  facet_wrap(~Categorie, scales = "free_y", ncol = 2) +
  geom_text(aes(label = ifelse(Abondance_Relative > 1.5, sprintf("%.1f%%", Abondance_Relative), "")), 
            position = position_stack(vjust = 0.5), size = 2.5, fontface = "bold") +
  labs(
    title = "Profil des Genres au sein du phylum majoritaire de chaque groupe",
    x = "Sites de prélèvement",
    y = "Abondance relative au sein du phylum (%)",
    fill = "Genres microbiens"
  ) +
  theme_bw() +
  theme(
    strip.text = element_text(face = "bold", size = 11),
    axis.text = element_text(face = "bold", size = 10),
    legend.text = element_text(size = 8),
    legend.title = element_text(face = "bold")
  )

print(plot3)
