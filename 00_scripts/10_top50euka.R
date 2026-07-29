#chargement de ggplot2 pour les graphiques
library(tidyverse)

#importation de la table d'assignation
df <- read.csv2("results_table_assignation.csv")         

#conservation des colonnes remplies uniquement 
df <- df[, 1:7]

#renommer les colonnes 
colnames(df) <- c("Taxonomy", "sed6_merge", "sed6_unmerge", "sed8_merge", "sed8_unmerge", "sed6total", "sed8total")

#conservation des eucaryotes uniquement en créant une nouvelle dataframe
df_clean <- df %>%
  filter(str_detect(Taxonomy, "d__Eukaryota") & str_detect(Taxonomy, "\\|s__")) %>% #ne garde que le nom de l'espèce
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy)) #stockage du nouveau nom dans la colonne taxon


# Graphique sed6 (Top 50 Espèces Eucaryotes)

top_sed6 <- top_n(df_clean, 50, wt = sed6total) #extraction des 50 lignes avec le plus de séquences 

plot_sed6 <- ggplot(top_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "pink") +
  labs(title = "SED6 - Top 50 Espèces Eucaryotes", x = "Nombre de reads", y = "Espèces") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 7))

print(plot_sed6)


# Graphique sed8 (Top 50 Espèces Eucaryotes)

top_sed8 <- top_n(df_clean, 50, wt = sed8total)

plot_sed8 <- ggplot(top_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "green") +
  labs(title = "SED8 - Top 50 Espèces Eucaryotes", x = "Nombre de reads", y = "Espèces") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 7))

print(plot_sed8)

########################TOP 30 pour les mammifères, poissons et plantes

library(tidyverse)

# importer les données
df <- read.csv2("results_table_assignation.csv")  
df <- df[, 1:7] # Garde uniquement les 7 premières colonnes
colnames(df) <- c("Taxonomy", "sed6_merge", "sed6_unmerge", "sed8_merge", "sed8_unmerge", "sed6total", "sed8total")

#séparation en 3 tableaux

# tableau mammifères
df_mammiferes <- df %>%
  filter(str_detect(Taxonomy, "c__Mammalia") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# tableau poissons
df_poissons <- df %>%
  filter(str_detect(Taxonomy, "c__Actinopteri") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# tableau plantes
df_plantes <- df %>%
  filter(str_detect(Taxonomy, "Viridiplantae") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))


# Graphiques sed6
#mammifères
top_mamm_sed6 <- top_n(df_mammiferes, 30, wt = sed6total)
plot_mamm_sed6 <- ggplot(top_mamm_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") + 
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 20000, by = 1000)) +
  labs(title = "SED6 - Top 30 Mammifères", x = "Reads", y = "Espèces") + 
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_mamm_sed6)

#poisson
top_pois_sed6 <- top_n(df_poissons, 30, wt = sed6total)
plot_pois_sed6 <- ggplot(top_pois_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") + 
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 20000, by = 1000)) +
  labs(title = "SED6 - Top 30 Poissons", x = "Reads", y = "Espèces") + 
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_pois_sed6)


#plantes
top_plan_sed6 <- top_n(df_plantes, 30, wt = sed6total)
plot_plan_sed6 <- ggplot(top_plan_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") + 
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 20000, by = 1000)) +
  labs(title = "SED6 - Top 30 Plantes", x = "Reads", y = "Espèces") + 
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_plan_sed6)



# Graphiques sed8
#mammifères
top_mamm_sed8 <- top_n(df_mammiferes, 30, wt = sed8total)
plot_mamm_sed8 <- ggplot(top_mamm_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "coral") + 
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 20000, by = 1000)) +
  labs(title = "SED8 - Top 30 Mammifères", x = "Reads", y = "Espèces") + 
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_mamm_sed8)

# poissons
top_pois_sed8 <- top_n(df_poissons, 30, wt = sed8total)
plot_pois_sed8 <- ggplot(top_pois_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "coral") + 
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 20000, by = 1000)) +
  labs(title = "SED8 - Top 30 Poissons", x = "Reads", y = "Espèces") + 
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_pois_sed8)

# plantes
top_plan_sed8 <- top_n(df_plantes, 30, wt = sed8total)
plot_plan_sed8 <- ggplot(top_plan_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "coral") + 
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 20000, by = 1000)) +
  labs(title = "SED8 - Top 30 Plantes", x = "Reads", y = "Espèces") + 
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_plan_sed8)


###############################SEPARATION DES MAMMIFERES MARINS ET TERRESTRES
######################## TOP 30 pour les mammifères, poissons et plantes (Avec séparation Marins/Terrestres)

library(tidyverse)


df <- read.csv2("results_table_assignation.csv")  
df <- df[, 1:7] 
colnames(df) <- c("Taxonomy", "sed6_merge", "sed6_unmerge", "sed8_merge", "sed8_unmerge", "sed6total", "sed8total")




mots_cles_marins <- "Cetacea|Delphinidae|Balaenopteridae|Phocidae|Otariidae|Odobenidae|Sirenia|Mysticeti|Odontoceti"

# Tableau A : Mammiferes marins
df_mamm_marins <- df %>%
  filter(str_detect(Taxonomy, "c__Mammalia") & str_detect(Taxonomy, "\\|s__")) %>%
  filter(str_detect(Taxonomy, mots_cles_marins)) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# Tableau B : Mammiferes terrestre
df_mamm_terrestres <- df %>%
  filter(str_detect(Taxonomy, "c__Mammalia") & str_detect(Taxonomy, "\\|s__")) %>%
#exlut les terrestres avec le !
  filter(!str_detect(Taxonomy, mots_cles_marins)) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# Tableau C : Poissons
df_poissons <- df %>%
  filter(str_detect(Taxonomy, "c__Actinopteri") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# Tableau D : Plantes
df_plantes <- df %>%
  filter(str_detect(Taxonomy, "Viridiplantae") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))


######################################################################
# 3. GRAPHIQUES POUR L'ECHANTILLON SED6
######################################################################

# mammiferes marins
# Pas de top 30 car peu d'especes
plot_mamm_marins_sed6 <- ggplot(df_mamm_marins, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED6 - Mammifères Marins", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_mamm_marins_sed6)

# mammiferes terrestres
top_mamm_terr_sed6 <- top_n(df_mamm_terrestres, 30, wt = sed6total)
plot_mamm_terr_sed6 <- ggplot(top_mamm_terr_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED6 - Top 30 Mammifères Terrestres", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_mamm_terr_sed6)

# poissons
top_pois_sed6 <- top_n(df_poissons, 30, wt = sed6total)
plot_pois_sed6 <- ggplot(top_pois_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED6 - Top 30 Poissons", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_pois_sed6)

# plantes
top_plan_sed6 <- top_n(df_plantes, 30, wt = sed6total)
plot_plan_sed6 <- ggplot(top_plan_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED6 - Top 30 Plantes", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_plan_sed6)


######################################################################
# 4. GRAPHIQUES POUR L'ECHANTILLON SED8 
######################################################################

# mammiferes marins
plot_mamm_marins_sed8 <- ggplot(df_mamm_marins, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "coral") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED8 - Mammifères Marins", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_mamm_marins_sed8)

# mammiferes terrestres
top_mamm_terr_sed8 <- top_n(df_mamm_terrestres, 30, wt = sed8total)
plot_mamm_terr_sed8 <- ggplot(top_mamm_terr_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "coral") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED8 - Top 30 Mammifères Terrestres", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_mamm_terr_sed8)

# poissons
top_pois_sed8 <- top_n(df_poissons, 30, wt = sed8total)
plot_pois_sed8 <- ggplot(top_pois_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "coral") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED8 - Top 30 Poissons", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_pois_sed8)

# plantes
top_plan_sed8 <- top_n(df_plantes, 30, wt = sed8total)
plot_plan_sed8 <- ggplot(top_plan_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "coral") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED8 - Top 30 Plantes", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_plan_sed8)

######################################################################
# TOP 30 : Mammifères (combinés), Poissons et Plantes
# Comparaison sed6 (Bleu) vs sed8 (Corail) sur la même figure
######################################################################

library(tidyverse)

# 1. IMPORTER ET NETTOYER LES DONNÉES
df <- read.csv2("results_table_assignation.csv")  
df <- df[, 1:7] # Garde uniquement les 7 premières colonnes
colnames(df) <- c("Taxonomy", "sed6_merge", "sed6_unmerge", "sed8_merge", "sed8_unmerge", "sed6total", "sed8total")

# Calcul de la somme des reads pour sélectionner le Top 30 global
df <- df %>%
  mutate(Total_Reads = sed6total + sed8total)


# 2. SÉPARATION EN TABLEAUX THÉMATIQUES 
# --- Tableau A : Tous les Mammifères ---
df_mammiferes <- df %>%
  filter(str_detect(Taxonomy, "c__Mammalia") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# --- Tableau B : Poissons ---
df_poissons <- df %>%
  filter(str_detect(Taxonomy, "c__Actinopteri") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# --- Tableau C : Plantes ---
df_plantes <- df %>%
  filter(str_detect(Taxonomy, "Viridiplantae") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))


# 3. FONCTION DE GÉNÉRATION DES GRAPHIQUES COMPARATIFS
plot_top30_comparatif <- function(data, titre_graphique) {
  
  # Extraction du Top 30 sur la somme des deux échantillons
  top30 <- data %>%
    slice_max(order_by = Total_Reads, n = 30, with_ties = FALSE) %>%
    select(Taxon, sed6total, sed8total, Total_Reads)
  

  top30_long <- top30 %>%
    pivot_longer(
      cols = c(sed6total, sed8total),
      names_to = "Echantillon",
      values_to = "Reads"
    ) %>%
    mutate(Echantillon = ifelse(Echantillon == "sed6total", "sed6", "sed8"))

  p <- ggplot(top30_long, aes(x = Reads, y = reorder(Taxon, Total_Reads), fill = Echantillon)) +
    geom_col(position = position_dodge(width = 0.7), width = 0.6) +
    scale_fill_manual(values = c("sed6" = "steelblue", "sed8" = "coral")) +
    labs(
      title = titre_graphique,
      x = "Nombre de Reads",
      y = NULL,
      fill = "Échantillon"
    ) +
    theme_minimal() +
    theme(
      axis.text.y = element_text(size = 8, face = "italic", color = "black"),
      legend.position = "top",
      plot.title = element_text(face = "bold", size = 12)
    )
  
  return(p)
}


######################################################################
# 4. GÉNÉRATION ET AFFICHAGE DES GRAPHIQUES
######################################################################

# --- Graphique 1 : Tous les Mammifères (Marins + Terrestres) ---
plot_mammiferes <- plot_top30_comparatif(df_mammiferes, "Top 30 Mammifères - Comparaison sed6 vs sed8")
print(plot_mammiferes)

# --- Graphique 2 : Poissons ---
plot_poissons <- plot_top30_comparatif(df_poissons, "Top 30 Poissons - Comparaison sed6 vs sed8")
print(plot_poissons)

# --- Graphique 3 : Plantes ---
plot_plantes <- plot_top30_comparatif(df_plantes, "Top 30 Plantes - Comparaison sed6 vs sed8")
print(plot_plantes)

