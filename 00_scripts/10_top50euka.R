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
  geom_col(fill = "blue") + labs(title = "SED6 - Top 30 Mammifères", x = "Reads", y = "Espèces") + theme_minimal()
print(plot_mamm_sed6)

#poisson
top_pois_sed6 <- top_n(df_poissons, 30, wt = sed6total)
plot_pois_sed6 <- ggplot(top_pois_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "blue") + labs(title = "SED6 - Top 30 Poissons", x = "Reads", y = "Espèces") + theme_minimal()
print(plot_pois_sed6)

#plantes
top_plan_sed6 <- top_n(df_plantes, 30, wt = sed6total)
plot_plan_sed6 <- ggplot(top_plan_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "blue") + labs(title = "SED6 - Top 30 Plantes", x = "Reads", y = "Espèces") + theme_minimal()
print(plot_plan_sed6)


# Graphiques sed8
#mammifères
top_mamm_sed8 <- top_n(df_mammiferes, 30, wt = sed8total)
plot_mamm_sed8 <- ggplot(top_mamm_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "orange") + labs(title = "SED8 - Top 30 Mammifères", x = "Reads", y = "Espèces") + theme_minimal()
print(plot_mamm_sed8)

# poissons
top_pois_sed8 <- top_n(df_poissons, 30, wt = sed8total)
plot_pois_sed8 <- ggplot(top_pois_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "orange") + labs(title = "SED8 - Top 30 Poissons", x = "Reads", y = "Espèces") + theme_minimal()
print(plot_pois_sed8)

# plantes
top_plan_sed8 <- top_n(df_plantes, 30, wt = sed8total)
plot_plan_sed8 <- ggplot(top_plan_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "orange") + labs(title = "SED8 - Top 30 Plantes", x = "Reads", y = "Espèces") + theme_minimal()
print(plot_plan_sed8)



