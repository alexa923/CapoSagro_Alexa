#chargement de ggplot2 pour les graphiques
library(tidyverse)

#importation de la table d'assignation
df <- read_csv2("results_table_assignation.csv")         

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

